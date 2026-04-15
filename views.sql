-- ==========================================
-- DATABASE VIEWS: MAXXBRANDS ERP SYSTEM
-- Purpose: Unified reporting and analytics layer
-- ==========================================

-- ------------------------------------------
-- 1. DASHBOARD & KPI VIEWS
-- ------------------------------------------

-- View: Executive KPI Dashboard
-- Summary of critical business metrics with Net/Gross splits
CREATE OR REPLACE VIEW MAXXBRANDS.vw_executive_dashboard AS
SELECT
    (SELECT COUNT(*) FROM MAXXBRANDS.sales WHERE TRUNC(sale_date) = TRUNC(CURRENT_DATE)) AS "Sales Today",
    (SELECT SUM(total_amount - (tax_amount + shipping_amount)) FROM MAXXBRANDS.sales WHERE TRUNC(sale_date) = TRUNC(CURRENT_DATE)) AS "Net Revenue Today",
    (SELECT SUM(total_amount) FROM MAXXBRANDS.sales WHERE TRUNC(sale_date) = TRUNC(CURRENT_DATE)) AS "Gross Revenue Today",
    (SELECT COUNT(*) FROM MAXXBRANDS.reorder_alerts WHERE status = 'ACTIVE') AS "Critical Stock Alerts",
    (SELECT COUNT(*) FROM MAXXBRANDS.purchase_orders WHERE status IN ('Pending', 'Approved', 'In Transit')) AS "Active POs",
    (SELECT COUNT(*) FROM MAXXBRANDS.fulfillments WHERE status IN ('PENDING', 'SCHEDULED') AND target_date = TRUNC(CURRENT_DATE)) AS "Fulfillments Due Today"
FROM DUAL;

-- View: Master Inventory Monitor
CREATE OR REPLACE VIEW MAXXBRANDS.vw_inventory_master AS
SELECT
    itm.item_code AS "SKU",
    itm.item_name AS "Product Name",
    loc.name AS "Location",
    inv.qty_on_hand AS "Physical Stock",
    inv.min_threshold AS "Min Threshold",
    CASE 
        WHEN inv.qty_on_hand <= 0 THEN 'EMERGENCY'
        WHEN inv.qty_on_hand <= inv.min_threshold THEN 'CRITICAL'
        WHEN inv.qty_on_hand <= (inv.min_threshold * 1.25) THEN 'LOW'
        ELSE 'OPTIMAL'
    END AS "Status"
FROM MAXXBRANDS.inventory inv
JOIN MAXXBRANDS.items itm ON inv.item_id = itm.item_id
JOIN MAXXBRANDS.locations loc ON inv.location_id = loc.location_id;

-- ------------------------------------------
-- 2. OPERATIONS & LOGISTICS
-- ------------------------------------------

-- View: Fulfillment Queue (Pickup/Delivery Dashboard)
CREATE OR REPLACE VIEW MAXXBRANDS.vw_fulfillment_queue AS
SELECT 
    f.target_date AS "Target Date",
    f.method AS "Method",
    f.status AS "Status",
    c.name AS "Customer",
    s.sap_ref_no AS "SAP Reference",
    e.first_name || ' ' || e.last_name AS "Handled By"
FROM MAXXBRANDS.fulfillments f
JOIN MAXXBRANDS.sales s ON f.sale_id = s.sale_id
JOIN MAXXBRANDS.customers c ON s.customer_id = c.customer_id
JOIN MAXXBRANDS.employees e ON f.handled_by = e.employee_id
WHERE f.status NOT IN ('COMPLETED', 'FAILED')
ORDER BY f.target_date ASC;

-- View: Procurement Pulse
CREATE OR REPLACE VIEW MAXXBRANDS.vw_procurement_pulse AS
SELECT 
    po.po_number AS "PO #",
    s.name AS "Supplier",
    po.order_date AS "Ordered",
    po.due_date AS "Expected",
    po.status AS "Status",
    po.total_po_amount AS "Amount",
    po.currency AS "Ccy"
FROM MAXXBRANDS.purchase_orders po
JOIN MAXXBRANDS.suppliers s ON po.supplier_id = s.supplier_id
WHERE po.status NOT IN ('Delivered', 'Cancelled');

-- ------------------------------------------
-- 3. ANALYTICS & INSIGHTS
-- ------------------------------------------

-- View: Product Sales Velocity (30-Day Trend)
-- Uses 30-day trailing sales to project stock depletion
CREATE OR REPLACE VIEW MAXXBRANDS.vw_sales_velocity AS
WITH sales_summary AS (
    SELECT 
        item_id, 
        SUM(qty) AS total_qty,
        COUNT(DISTINCT TRUNC(s.sale_date)) as active_days
    FROM MAXXBRANDS.sales_items si
    JOIN MAXXBRANDS.sales s ON si.sale_id = s.sale_id
    WHERE s.sale_date >= TRUNC(SYSDATE) - 29 -- Last 30 full days including today
    GROUP BY item_id
)
SELECT 
    i.item_code AS "SKU",
    i.item_name AS "Product",
    COALESCE(ss.total_qty, 0) AS "Units Sold (30d)",
    ROUND(COALESCE(ss.total_qty, 0) / 30.0, 2) AS "Daily Velocity",
    inv.qty_on_hand AS "Current Stock",
    CASE 
        WHEN COALESCE(ss.total_qty, 0) > 0 THEN ROUND(inv.qty_on_hand / (ss.total_qty / 30.0), 1)
        ELSE 999 -- Infinite days stock remaining
    END AS "Days Remaining"
FROM MAXXBRANDS.items i
LEFT JOIN sales_summary ss ON i.item_id = ss.item_id
JOIN MAXXBRANDS.inventory inv ON i.item_id = inv.item_id
WHERE inv.location_id = MAXXBRANDS.PKG_CORE.GET_DEFAULT_LOCATION_ID();

-- View: Supplier Reliability Index
CREATE OR REPLACE VIEW MAXXBRANDS.vw_supplier_reliability AS
SELECT 
    s.name AS "Supplier",
    COUNT(po.po_id) AS "Total Orders",
    ROUND(AVG(p.received_date - po.order_date), 1) AS "Actual Lead Time (Avg)",
    ROUND(AVG(sip.lead_time_days), 1) AS "Target Lead Time (Avg)",
    ROUND(AVG(p.received_date - po.order_date) - AVG(sip.lead_time_days), 1) AS "Variance (Days)"
FROM MAXXBRANDS.suppliers s
JOIN MAXXBRANDS.purchase_orders po ON s.supplier_id = po.supplier_id
JOIN MAXXBRANDS.purchases p ON po.po_id = p.po_id
JOIN MAXXBRANDS.supplier_item_prices sip ON s.supplier_id = sip.supplier_id AND sip.item_id IN (SELECT item_id FROM MAXXBRANDS.purchase_order_lines WHERE po_id = po.po_id)
GROUP BY s.name;

-- ------------------------------------------
-- 4. FINANCIAL TRACKING
-- ------------------------------------------

-- View: Payment Aging & Status
CREATE OR REPLACE VIEW MAXXBRANDS.vw_payment_summary AS
SELECT 
    p.related_type AS "Type",
    p.related_id AS "Ref ID",
    p.amount AS "Paid Amount",
    p.payment_date AS "Date",
    p.payment_method AS "Method",
    p.reference_no AS "Ref No"
FROM MAXXBRANDS.payments p;

-- ------------------------------------------
-- 5. NEW: POS & INVENTORY SPECIALIZED VIEWS
-- ------------------------------------------

-- View: POS Daily Transaction Summary
-- Shows all transactions for the current day with employee and customer details
CREATE OR REPLACE VIEW MAXXBRANDS.vw_pos_daily_summary AS
SELECT 
    s.sap_ref_no AS "Receipt #",
    s.sale_date AS "Timestamp",
    c.name AS "Customer",
    e.first_name || ' ' || e.last_name AS "Cashier",
    s.total_amount AS "Total PHP",
    s.payment_terms AS "Terms",
    (SELECT LISTAGG(i.item_name, ', ') WITHIN GROUP (ORDER BY i.item_name) 
     FROM MAXXBRANDS.sales_items si 
     JOIN MAXXBRANDS.items i ON si.item_id = i.item_id 
     WHERE si.sale_id = s.sale_id) AS "Items Sold"
FROM MAXXBRANDS.sales s
JOIN MAXXBRANDS.customers c ON s.customer_id = c.customer_id
JOIN MAXXBRANDS.employees e ON s.processed_by = e.employee_id
WHERE TRUNC(s.sale_date) = TRUNC(CURRENT_DATE);

-- View: Inventory Asset Valuation
-- Calculates the monetary value of current physical stock based on SRP
CREATE OR REPLACE VIEW MAXXBRANDS.vw_inventory_valuation AS
SELECT 
    loc.name AS "Location",
    cat.name AS "Category",
    itm.item_name AS "Product",
    inv.qty_on_hand AS "Stock",
    itm.srp AS "Unit Price (SRP)",
    (inv.qty_on_hand * itm.srp) AS "Total Asset Value"
FROM MAXXBRANDS.inventory inv
JOIN MAXXBRANDS.items itm ON inv.item_id = itm.item_id
JOIN MAXXBRANDS.item_types typ ON itm.type_id = typ.type_id
JOIN MAXXBRANDS.categories cat ON typ.category_id = cat.category_id
JOIN MAXXBRANDS.locations loc ON inv.location_id = loc.location_id
ORDER BY "Total Asset Value" DESC;

COMMIT;
