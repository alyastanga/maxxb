-- ==========================================
-- AUTOMATION LOGIC (TRIGGERS): MAXXBRANDS ERP
-- ==========================================

-- 1. INVENTORY SYNCHRONIZATION
-- Sync Stock on Purchase Fulfillment
CREATE OR REPLACE TRIGGER MAXXBRANDS.trg_sync_inv_on_receipt
AFTER INSERT ON MAXXBRANDS.purchases
FOR EACH ROW
BEGIN
  -- Increment qty_on_hand for all received items in the PO
  UPDATE MAXXBRANDS.inventory i
  SET i.qty_on_hand = i.qty_on_hand + (
    SELECT pol.qty_received 
    FROM MAXXBRANDS.purchase_order_lines pol 
    WHERE pol.po_id = :NEW.po_id AND pol.item_id = i.item_id
  )
  WHERE i.location_id = (SELECT location_id FROM MAXXBRANDS.purchase_orders WHERE po_id = :NEW.po_id)
  AND i.item_id IN (SELECT item_id FROM MAXXBRANDS.purchase_order_lines WHERE po_id = :NEW.po_id);
END;
/

-- Sync Stock on Sales Fulfillment Completion
CREATE OR REPLACE TRIGGER MAXXBRANDS.trg_sync_inv_on_fulfillment
AFTER UPDATE OF status ON MAXXBRANDS.fulfillments
FOR EACH ROW
WHEN (NEW.status = 'COMPLETED')
BEGIN
  UPDATE MAXXBRANDS.inventory i
  SET i.qty_on_hand = i.qty_on_hand - (
    SELECT SUM(si.qty)
    FROM MAXXBRANDS.sales_items si
    WHERE si.sale_id = :NEW.sale_id AND si.item_id = i.item_id
  )
  WHERE i.location_id = MAXXBRANDS.PKG_CORE.GET_DEFAULT_LOCATION_ID()
  AND i.item_id IN (SELECT item_id FROM MAXXBRANDS.sales_items WHERE sale_id = :NEW.sale_id);
END;
/

-- 2. VALIDATION & DATA INTEGRITY
-- Prevent Overselling (Objective 6)
CREATE OR REPLACE TRIGGER MAXXBRANDS.trg_validate_stock_before_sale
BEFORE INSERT OR UPDATE ON MAXXBRANDS.sales_items
FOR EACH ROW
DECLARE
    v_on_hand NUMBER;
BEGIN
    SELECT qty_on_hand INTO v_on_hand 
    FROM MAXXBRANDS.inventory 
    WHERE item_id = :NEW.item_id AND location_id = MAXXBRANDS.PKG_CORE.GET_DEFAULT_LOCATION_ID();

    IF v_on_hand < :NEW.qty THEN
        RAISE_APPLICATION_ERROR(-20001, 'Insufficient stock for SKU: ' || :NEW.item_id || '. Available: ' || v_on_hand);
    END IF;
END;
/

-- 3. REORDER AUTOMATION (Objective 3)
-- Detect Stock Threshold and Create Alert (COMPOUND to avoid Mutation Chain)
CREATE OR REPLACE TRIGGER MAXXBRANDS.trg_monitor_stock_threshold
FOR UPDATE OF qty_on_hand ON MAXXBRANDS.inventory
COMPOUND TRIGGER

    -- Collection to hold alerts detected during the transaction
    TYPE t_alert_rec IS RECORD (
        item_id        NUMBER,
        location_id    NUMBER,
        qty_on_hand    NUMBER,
        min_threshold  NUMBER
    );
    TYPE t_alert_list IS TABLE OF t_alert_rec;
    v_alerts t_alert_list := t_alert_list();

    -- 1. AFTER EACH ROW: Register items that hit the threshold
    AFTER EACH ROW IS
    BEGIN
        IF :NEW.qty_on_hand <= :NEW.min_threshold THEN
            v_alerts.EXTEND;
            v_alerts(v_alerts.COUNT).item_id       := :NEW.item_id;
            v_alerts(v_alerts.COUNT).location_id   := :NEW.location_id;
            v_alerts(v_alerts.COUNT).qty_on_hand   := :NEW.qty_on_hand;
            v_alerts(v_alerts.COUNT).min_threshold := :NEW.min_threshold;
        END IF;
    END AFTER EACH ROW;

    -- 2. AFTER STATEMENT: Insert alerts into the master table
    -- Since the inventory operation is finished, reorder_alerts can now fire its own PO logic safely
    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1..v_alerts.COUNT LOOP
            INSERT INTO MAXXBRANDS.reorder_alerts (item_id, location_id, current_qty, threshold_qty)
            VALUES (v_alerts(i).item_id, v_alerts(i).location_id, v_alerts(i).qty_on_hand, v_alerts(i).min_threshold);
        END LOOP;
        
        v_alerts.DELETE; -- Cleanup
    END AFTER STATEMENT;

END trg_monitor_stock_threshold;
/

-- Automated PO Generation for Alerts (BATCHED & IDEMPOTENT)
CREATE OR REPLACE TRIGGER MAXXBRANDS.trg_auto_po_on_alert
FOR INSERT ON MAXXBRANDS.reorder_alerts
COMPOUND TRIGGER

    -- 1. BEFORE STATEMENT: Reset the session collection
    BEFORE STATEMENT IS 
    BEGIN
        MAXXBRANDS.PKG_PROCUREMENT.CLEAR_ALERTS;
    END BEFORE STATEMENT;

    -- 2. BEFORE EACH ROW: Mark as PO_CREATED immediately to avoid mutating statement updates
    BEFORE EACH ROW IS
    BEGIN
        IF :NEW.status = 'ACTIVE' THEN
            :NEW.status := 'PO_CREATED';
        END IF;
    END BEFORE EACH ROW;

    -- 3. AFTER EACH ROW: Register the alert for processing
    AFTER EACH ROW IS
    BEGIN
        -- Pass the threshold from the alert record to avoid inventory mutation queries
        MAXXBRANDS.PKG_PROCUREMENT.REGISTER_REORDER_ALERT(:NEW.item_id, :NEW.location_id, :NEW.threshold_qty);
    END AFTER EACH ROW;

    -- 4. AFTER STATEMENT: Process all collected reorders in one batch
    AFTER STATEMENT IS
    BEGIN
        MAXXBRANDS.PKG_PROCUREMENT.PROCESS_REORDERS;
    END AFTER STATEMENT;

END trg_auto_po_on_alert;
/

-- 4. COMPREHENSIVE AUDIT LOGGING (Objective 5)
-- Unified Audit Trigger for Item/Sale/Payment
CREATE OR REPLACE TRIGGER MAXXBRANDS.trg_audit_core_changes
AFTER INSERT OR UPDATE OR DELETE ON MAXXBRANDS.sales
FOR EACH ROW
DECLARE
    v_user_id NUMBER;
BEGIN
    INSERT INTO MAXXBRANDS.audit_logs (user_id, action_type, log_details)
    VALUES (MAXXBRANDS.PKG_CORE.GET_SYSTEM_USER_ID(), 'SALES_ACTIVITY', 'Sale ID: ' || :NEW.sale_id || ' status: ' || :NEW.total_amount);
END;
/

COMMIT;
