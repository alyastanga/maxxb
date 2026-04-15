-- ==========================================
-- MAXXBRANDS ERP: DATA CLEANUP SCRIPT
-- ==========================================
-- Use this to quickly reset the database before reloading seed.sql

-- 1. Transaction & Tracking Logs (Deepest Children)
TRUNCATE TABLE MAXXBRANDS.audit_logs;
TRUNCATE TABLE MAXXBRANDS.reorder_alerts;
TRUNCATE TABLE MAXXBRANDS.po_tracking;
TRUNCATE TABLE MAXXBRANDS.payments;
TRUNCATE TABLE MAXXBRANDS.fulfillments;
TRUNCATE TABLE MAXXBRANDS.attendance;

-- 2. Transaction Details
TRUNCATE TABLE MAXXBRANDS.sales_items;
TRUNCATE TABLE MAXXBRANDS.purchase_order_lines;
TRUNCATE TABLE MAXXBRANDS.purchases;

-- 3. Transaction Headers
TRUNCATE TABLE MAXXBRANDS.sales;
TRUNCATE TABLE MAXXBRANDS.purchase_orders;

-- 4. Core Catalog & Inventory
TRUNCATE TABLE MAXXBRANDS.inventory;
TRUNCATE TABLE MAXXBRANDS.supplier_item_prices;
TRUNCATE TABLE MAXXBRANDS.items;
TRUNCATE TABLE MAXXBRANDS.item_types;
TRUNCATE TABLE MAXXBRANDS.categories;

-- 5. Entities & Logistics
TRUNCATE TABLE MAXXBRANDS.customers;
TRUNCATE TABLE MAXXBRANDS.suppliers;
TRUNCATE TABLE MAXXBRANDS.locations;

-- 6. User Management
TRUNCATE TABLE MAXXBRANDS.users;
TRUNCATE TABLE MAXXBRANDS.employees;
TRUNCATE TABLE MAXXBRANDS.roles;

COMMIT;
