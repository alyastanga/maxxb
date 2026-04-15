CREATE OR REPLACE PACKAGE MAXXBRANDS.PKG_PROCUREMENT AS
    -- Global collection type for capturing reorder alerts in a statement
    TYPE t_alert_rec IS RECORD (
        item_id       NUMBER,
        location_id   NUMBER,
        min_threshold NUMBER
    );
    TYPE t_alert_list IS TABLE OF t_alert_rec;

    -- Procedure to register an alert during a row-level trigger
    PROCEDURE REGISTER_REORDER_ALERT(p_item_id IN NUMBER, p_location_id IN NUMBER, p_min_threshold IN NUMBER);

    -- Procedure to process all registered alerts (Batching + Idempotency)
    PROCEDURE PROCESS_REORDERS;

    -- Internal: Clear the current session collection
    PROCEDURE CLEAR_ALERTS;

END PKG_PROCUREMENT;
/

CREATE OR REPLACE PACKAGE BODY MAXXBRANDS.PKG_PROCUREMENT AS
    -- Session-level collection to hold reorder requests
    v_alerts t_alert_list := t_alert_list();

    PROCEDURE CLEAR_ALERTS IS
    BEGIN
        v_alerts.DELETE;
    END CLEAR_ALERTS;

    PROCEDURE REGISTER_REORDER_ALERT(p_item_id IN NUMBER, p_location_id IN NUMBER, p_min_threshold IN NUMBER) IS
    BEGIN
        v_alerts.EXTEND;
        v_alerts(v_alerts.COUNT).item_id       := p_item_id;
        v_alerts(v_alerts.COUNT).location_id   := p_location_id;
        v_alerts(v_alerts.COUNT).min_threshold := p_min_threshold;
    END REGISTER_REORDER_ALERT;

    PROCEDURE PROCESS_REORDERS IS
        v_supplier_id   NUMBER;
        v_po_id         NUMBER;
        v_managed_by    NUMBER;
        v_unit_cost     NUMBER;
        v_reorder_qty   NUMBER;
        v_min_threshold NUMBER;
        v_log_id        NUMBER;
    BEGIN
        -- 1. Identify Default Purchasing Manager (Jerick Remo)
        SELECT employee_id INTO v_managed_by FROM MAXXBRANDS.employees WHERE last_name = 'Remo' AND ROWNUM = 1;

        -- 2. Loop through collected alerts
        FOR i IN 1..v_alerts.COUNT LOOP
            -- A. Identify Primary Supplier (CHEAPEST)
            BEGIN
                SELECT supplier_id, unit_cost INTO v_supplier_id, v_unit_cost
                FROM (
                    SELECT supplier_id, unit_cost 
                    FROM MAXXBRANDS.supplier_item_prices 
                    WHERE item_id = v_alerts(i).item_id 
                    ORDER BY unit_cost ASC
                ) WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    CONTINUE; -- Skip if no supplier defined
            END;

            -- B. Idempotency Check: Find existing SYSTEM Pending PO for this Supplier/Location
            BEGIN
                SELECT po_id INTO v_po_id
                FROM MAXXBRANDS.purchase_orders
                WHERE supplier_id = v_supplier_id
                  AND location_id = v_alerts(i).location_id
                  AND status = 'Pending'
                  AND po_number LIKE 'AUTO-PO-%'
                  AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Create NEW Header if not found
                    INSERT INTO MAXXBRANDS.purchase_orders (
                        supplier_id, requested_by, status, location_id, order_date, po_number
                    ) VALUES (
                        v_supplier_id, v_managed_by, 'Pending', v_alerts(i).location_id, CURRENT_DATE, 
                        'AUTO-PO-' || TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDDHH24MISS') || '-' || v_supplier_id
                    ) RETURNING po_id INTO v_po_id;
            END;

            -- C. Calculate Reorder Qty (Standard: 2x Threshold)
            v_reorder_qty := v_alerts(i).min_threshold * 2;

            -- D. Find or Create Line Item
            MERGE INTO MAXXBRANDS.purchase_order_lines pol
            USING (SELECT v_po_id as po_id, v_alerts(i).item_id as item_id FROM DUAL) src
               ON (pol.po_id = src.po_id AND pol.item_id = src.item_id)
            WHEN MATCHED THEN
                UPDATE SET suggested_qty = suggested_qty + v_reorder_qty,
                           line_total    = (suggested_qty + v_reorder_qty) * v_unit_cost
            WHEN NOT MATCHED THEN
                INSERT (po_id, item_id, suggested_qty, unit_cost, line_total)
                VALUES (v_po_id, v_alerts(i).item_id, v_reorder_qty, v_unit_cost, v_reorder_qty * v_unit_cost);

            -- E. Update PO Total
            UPDATE MAXXBRANDS.purchase_orders 
            SET total_po_amount = (SELECT SUM(line_total) FROM MAXXBRANDS.purchase_order_lines WHERE po_id = v_po_id)
            WHERE po_id = v_po_id;

        END LOOP;

        -- 3. Cleanup Batch
        CLEAR_ALERTS;

    EXCEPTION
        WHEN OTHERS THEN
            CLEAR_ALERTS; -- Ensure we don't leak memory on error
            RAISE;
    END PROCESS_REORDERS;

END PKG_PROCUREMENT;
/
