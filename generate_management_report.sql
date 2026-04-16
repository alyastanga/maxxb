-- ==========================================
-- MAXXBRANDS ERP: MANAGEMENT REPORTING SCRIPT
-- Purpose: Generate a full business snapshot from the reporting views
-- Usage: Run this in SQLcl, SQL*Plus, or any SQL console
-- ==========================================

SET FEEDBACK OFF;
SET PAGESIZE 50;
SET LINESIZE 150;
SET HEADING ON;

PROMPT
PROMPT ============================================================
PROMPT MAXXBRANDS ERP: EXECUTIVE MANAGEMENT REPORT
PROMPT Generated at: &&_DATE
PROMPT ============================================================

-- 1. EXECUTIVE KPIs
PROMPT [1] EXECUTIVE KPI DASHBOARD
PROMPT ------------------------------------------------------------
SELECT * FROM MAXXBRANDS.vw_executive_dashboard;

-- 2. INVENTORY SNAPSHOT
PROMPT
PROMPT [2] CRITICAL INVENTORY MONITOR (Top 10 Alerts)
PROMPT ------------------------------------------------------------
SELECT "SKU", "Product Name", "Location", "Stock", "Status"
FROM MAXXBRANDS.vw_inventory_master
WHERE "Status" IN ('EMERGENCY', 'CRITICAL', 'LOW')
FETCH FIRST 10 ROWS ONLY;

PROMPT
PROMPT [3] INVENTORY ASSET VALUATION (By Location)
PROMPT ------------------------------------------------------------
SELECT "Location", "Category", SUM("Total Asset Value") as "Total Value"
FROM MAXXBRANDS.vw_inventory_valuation
GROUP BY "Location", "Category"
ORDER BY "Total Value" DESC;

-- 3. SALES & VELOCITY
PROMPT
PROMPT [4] TOP MOVEING PRODUCTS (FAST MOVERS)
PROMPT ------------------------------------------------------------
SELECT "SKU", "Product", "Units Sold (30d)", "Days Remaining"
FROM MAXXBRANDS.vw_sales_velocity
WHERE "Demand Status" = 'FAST MOVER'
ORDER BY "Units Sold (30d)" DESC;

PROMPT
PROMPT [5] TODAY'S POS TRANSACTIONS
PROMPT ------------------------------------------------------------
SELECT "Receipt #", "Customer", "Total PHP", "Items Sold"
FROM MAXXBRANDS.vw_pos_daily_summary;

-- 4. LOGISTICS & PROCUREMENT
PROMPT
PROMPT [6] PENDING FULFILLMENTS (LOGISTICS QUEUE)
PROMPT ------------------------------------------------------------
SELECT "Target Date", "Method", "Status", "Customer"
FROM MAXXBRANDS.vw_fulfillment_queue
FETCH FIRST 5 ROWS ONLY;

PROMPT
PROMPT [7] SUPPLIER LEAD-TIME ACCURACY (VARIANCE)
PROMPT ------------------------------------------------------------
SELECT "Supplier", "Actual Lead Time (Avg)", "Variance (Days)"
FROM MAXXBRANDS.vw_supplier_reliability;

-- 5. PERSONNEL
PROMPT
PROMPT [8] DAILY ATTENDANCE SUMMARY
PROMPT ------------------------------------------------------------
SELECT "Employee", "Clock In", "Clock Out", "Hours Worked", "Status"
FROM MAXXBRANDS.vw_attendance_summary
WHERE TRUNC("Date") = TRUNC(SYSDATE);

PROMPT
PROMPT ============================================================
PROMPT END OF REPORT
PROMPT ============================================================
PROMPT
