-- ==========================================
-- SEED DATA: PENDING FULFILLMENTS
-- Purpose: Test 'vw_fulfillment_queue' with non-completed statuses
-- ==========================================

DECLARE
    v_sale_id     NUMBER;
    v_customer_id NUMBER;
    v_employee_id NUMBER;
    v_item_id     NUMBER;
    v_price       NUMBER;
BEGIN
    -- Resolve common employee (Kurt Rañeses)
    SELECT employee_id INTO v_employee_id FROM MAXXBRANDS.employees WHERE last_name = 'Rañeses' AND ROWNUM = 1;

    -- 1. PENDING PICK-UP
    SELECT customer_id INTO v_customer_id FROM MAXXBRANDS.customers WHERE name = 'John Doe' AND ROWNUM = 1;
    SELECT item_id, srp INTO v_item_id, v_price FROM MAXXBRANDS.items WHERE item_code = 'SD-ALFA-CT' AND ROWNUM = 1;

    INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms)
    VALUES ('PEND-001', v_customer_id, v_employee_id, CURRENT_TIMESTAMP, v_price, 'Full Payment')
    RETURNING sale_id INTO v_sale_id;

    INSERT INTO MAXXBRANDS.sales_items (sale_id, item_id, qty, unit_price, line_total, allocation_status)
    VALUES (v_sale_id, v_item_id, 1, v_price, v_price, 'ALLOCATED');

    INSERT INTO MAXXBRANDS.fulfillments (sale_id, method, status, target_date, handled_by)
    VALUES (v_sale_id, 'Pick-up', 'PENDING', TRUNC(SYSDATE) + 1, v_employee_id);


    -- 2. SCHEDULED DELIVERY
    SELECT customer_id INTO v_customer_id FROM MAXXBRANDS.customers WHERE name = 'Ayala Land Inc.' AND ROWNUM = 1;
    SELECT item_id, srp INTO v_item_id, v_price FROM MAXXBRANDS.items WHERE item_code = 'IS-MILO-CNSL' AND ROWNUM = 1;

    INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms)
    VALUES ('PEND-002', v_customer_id, v_employee_id, CURRENT_TIMESTAMP, v_price, 'Full Payment')
    RETURNING sale_id INTO v_sale_id;

    INSERT INTO MAXXBRANDS.sales_items (sale_id, item_id, qty, unit_price, line_total, allocation_status)
    VALUES (v_sale_id, v_item_id, 1, v_price, v_price, 'ALLOCATED');

    INSERT INTO MAXXBRANDS.fulfillments (sale_id, method, status, target_date, handled_by)
    VALUES (v_sale_id, 'Truck Delivery', 'SCHEDULED', TRUNC(SYSDATE) + 2, v_employee_id);


    -- 3. IN-TRANSIT DELIVERY
    SELECT item_id, srp INTO v_item_id, v_price FROM MAXXBRANDS.items WHERE item_code = 'HD-RAMP-TL' AND ROWNUM = 1;

    INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms)
    VALUES ('PEND-003', v_customer_id, v_employee_id, CURRENT_TIMESTAMP, v_price, 'Full Payment')
    RETURNING sale_id INTO v_sale_id;

    INSERT INTO MAXXBRANDS.sales_items (sale_id, item_id, qty, unit_price, line_total, allocation_status)
    VALUES (v_sale_id, v_item_id, 1, v_price, v_price, 'ALLOCATED');

    INSERT INTO MAXXBRANDS.fulfillments (sale_id, method, status, target_date, handled_by)
    VALUES (v_sale_id, 'Van Delivery', 'IN-TRANSIT', TRUNC(SYSDATE), v_employee_id);

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Successfully generated 3 pending/scheduled fulfillment seeds.');
END;
/
