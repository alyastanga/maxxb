-- ==========================================
-- SEED DATA: HIGH-VELOCITY SALES (2026-04-16)
-- Purpose: Demonstrate 'FAST MOVER' logic and robust insertion
-- ==========================================

DECLARE
    v_sale_id     NUMBER;
    v_customer_id NUMBER;
    v_employee_id NUMBER;
    v_item_id     NUMBER;
    v_price       NUMBER;
BEGIN
    -- 1. Setup Reference Data
    SELECT customer_id INTO v_customer_id FROM MAXXBRANDS.customers WHERE name = 'John Doe' AND ROWNUM = 1;
    SELECT employee_id INTO v_employee_id FROM MAXXBRANDS.employees WHERE last_name = 'Rañeses' AND ROWNUM = 1;
    SELECT item_id, srp INTO v_item_id, v_price FROM MAXXBRANDS.items WHERE item_code = 'SD-SHIBA-TVS' AND ROWNUM = 1;

    -- 2. Bulk Insert (10 Transactions)
    -- This ensures the item hits the 'FAST MOVER' threshold in your views
    FOR i IN 1..10 LOOP
        
        -- Header
        INSERT INTO MAXXBRANDS.sales (
            sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms
        ) VALUES (
            'POS-' || TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD') || '-00' || i, 
            v_customer_id, v_employee_id, CURRENT_TIMESTAMP, v_price, 'Full Payment'
        ) RETURNING sale_id INTO v_sale_id;

        -- Line Item
        INSERT INTO MAXXBRANDS.sales_items (
            sale_id, item_id, qty, unit_price, line_total, allocation_status
        ) VALUES (
            v_sale_id, v_item_id, 1, v_price, v_price, 'RELEASED'
        );

        -- Fulfillment (Completed immediately to update inventory)
        INSERT INTO MAXXBRANDS.fulfillments (
            sale_id, method, status, target_date, actual_completion_date, handled_by
        ) VALUES (
            v_sale_id, 'Pick-up', 'COMPLETED', TRUNC(SYSDATE), CURRENT_TIMESTAMP, v_employee_id
        );

        -- Payment
        INSERT INTO MAXXBRANDS.payments (
            related_type, related_id, amount, payment_method, reference_no, logged_by
        ) VALUES (
            'SALE', v_sale_id, v_price, 'Cash', 'CASH-AUTO-' || i, v_employee_id
        );
        
    END LOOP;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Successfully generated 10 high-velocity sales.');
END;
/
