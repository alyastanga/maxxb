-- ==========================================
-- FINAL ID-LESS BULK SEED DATA (FULL ERP)
-- ==========================================
-- This script fully populates the Maxxbrands ERP with the EXACT original volume.
-- All relations are linked via subqueries to avoid hardcoded IDs.

SET DEFINE OFF;

-- 1. ROLES
INSERT INTO roles (name) VALUES ('System Administrator');
INSERT INTO roles (name) VALUES ('Store Manager');
INSERT INTO roles (name) VALUES ('Cashier');
INSERT INTO roles (name) VALUES ('Warehouse Manager');
INSERT INTO roles (name) VALUES ('Inventory Clerk');
INSERT INTO roles (name) VALUES ('Logistics Driver');

-- 2. EMPLOYEES
INSERT INTO employees (role_id, first_name, last_name, email) VALUES ((SELECT role_id FROM roles WHERE name = 'System Administrator'), 'Peter', 'Dela Cruz', 'peter.delacruz@com');
INSERT INTO employees (role_id, first_name, last_name, email) VALUES ((SELECT role_id FROM roles WHERE name = 'Store Manager'), 'Hanz', 'Mapua', 'hanz.mapua@com');
INSERT INTO employees (role_id, first_name, last_name, email) VALUES ((SELECT role_id FROM roles WHERE name = 'Cashier'), 'Kurt', 'Rañeses', 'kurt.raneses@com');
INSERT INTO employees (role_id, first_name, last_name, email) VALUES ((SELECT role_id FROM roles WHERE name = 'Warehouse Manager'), 'Jerick', 'Remo', 'jerick.remo@com');
INSERT INTO employees (role_id, first_name, last_name, email) VALUES ((SELECT role_id FROM roles WHERE name = 'Logistics Driver'), 'Sean', 'Coquia', 'sean.coquia@com');

-- 3. USERS
INSERT INTO users (employee_id, username, password_hash) VALUES ((SELECT employee_id FROM employees WHERE email = 'peter.delacruz@com'), 'admin_peter', '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');
INSERT INTO users (employee_id, username, password_hash) VALUES ((SELECT employee_id FROM employees WHERE email = 'hanz.mapua@com'), 'mgr_hanz', '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');
INSERT INTO users (employee_id, username, password_hash) VALUES ((SELECT employee_id FROM employees WHERE email = 'kurt.raneses@com'), 'cashier_kurt', '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');
INSERT INTO users (employee_id, username, password_hash) VALUES ((SELECT employee_id FROM employees WHERE email = 'jerick.remo@com'), 'warehouse_jerick', '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');
INSERT INTO users (employee_id, username, password_hash) VALUES ((SELECT employee_id FROM employees WHERE email = 'sean.coquia@com'), 'logistics_sean', '$2a$12$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy');

-- 4. CATEGORIES
INSERT INTO categories (name) VALUES ('Living Room');
INSERT INTO categories (name) VALUES ('Lighting');
INSERT INTO categories (name) VALUES ('Home Decor');
INSERT INTO categories (name) VALUES ('Dining Room');
INSERT INTO categories (name) VALUES ('Bedroom');
INSERT INTO categories (name) VALUES ('Wardrobe');
INSERT INTO categories (name) VALUES ('Desks');
INSERT INTO categories (name) VALUES ('Office');
INSERT INTO categories (name) VALUES ('Shelves');
INSERT INTO categories (name) VALUES ('Totguard');

-- 5. ITEM TYPES
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'TV Stand');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Center Table');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Lighting'), 'Lamp');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Home Decor'), 'Area Rug');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Console Table');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Bookcase');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Lounge Chair');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Magazine Rack');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Room Divider');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Sofa');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Furniture');
INSERT INTO item_types (category_id, name) VALUES ((SELECT category_id FROM categories WHERE name = 'Living Room'), 'Shelf');

-- 6. ITEMS (THE FULL 31 LIST)
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('SD-SHIBA-TVS', (SELECT type_id FROM item_types WHERE name = 'TV Stand'), 'Songdream Shiba Tv Stand', 30800);
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('SD-ALFA-CT', (SELECT type_id FROM item_types WHERE name = 'Center Table'), 'Songdream Alfa Center Table', 17080);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('HD-RAMP-TL', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Halo Design Rampel Table Lamp', '14 x 14 x 29.25 inch', 7245);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('HD-FRITZ-TL', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Halo Design Fritz Table Lamp', '12 x 12 x 20.5 inch', 4795);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('HD-HEST-RUG', (SELECT type_id FROM item_types WHERE name = 'Area Rug'), 'Halo Design Heston Area Rug', '230 x 160 cm', 11725);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('HD-ORIA-RUG', (SELECT type_id FROM item_types WHERE name = 'Area Rug'), 'Halo Design Oriana Area Rug', '230 x 160 cm', 14320);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('IS-MILO-CNSL', (SELECT type_id FROM item_types WHERE name = 'Console Table'), 'Interior Source Milo Console Table', '160 cm', 36610);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('IS-DAMO-BKC', (SELECT type_id FROM item_types WHERE name = 'Bookcase'), 'Interior Source Damo Bookcase (Black)', '1.5 m', 66920);
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('IS-MARI-LCHR', (SELECT type_id FROM item_types WHERE name = 'Lounge Chair'), 'Interior Source Marion Lounge Chair', 34020);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('IS-MILO-ST', (SELECT type_id FROM item_types WHERE name = 'Center Table'), 'Interior Source Milo Side Table', '1.5 m', 20755);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('IS-MILO-CT', (SELECT type_id FROM item_types WHERE name = 'Center Table'), 'Interior Source Milo Center Table', '120 x 60 x 46 cm', 37730);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('IS-PRAT-CNSL', (SELECT type_id FROM item_types WHERE name = 'Console Table'), 'Interior Source Prato Duo Console Table', '1.5 m', 41160);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('IS-PRAT-ST', (SELECT type_id FROM item_types WHERE name = 'Center Table'), 'Interior Source Prato Duo Side Table', '56 x 66 x 58 cm', 25375);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-MAG-MRCK', (SELECT type_id FROM item_types WHERE name = 'Magazine Rack'), 'Songdream Mag Magazine Rack', '150 x 60 x 210 cm', 6120);
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('SD-REED-DIV', (SELECT type_id FROM item_types WHERE name = 'Room Divider'), 'Songdream Reed Divider', 77280);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-CROS-BKC', (SELECT type_id FROM item_types WHERE name = 'Bookcase'), 'Songdream Cross Bookcase', '1958 mm', 51720);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-RACK', (SELECT type_id FROM item_types WHERE name = 'Room Divider'), 'Songdream Rack', '1000 x 380 x 1090 mm', 31600);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-ELF-DEC', (SELECT type_id FROM item_types WHERE name = 'Furniture'), 'Songdream Elf', '1000 mm', 6000);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-SWNG-BKC', (SELECT type_id FROM item_types WHERE name = 'Bookcase'), 'Songdream Swing Bookcase Natural Walnut', '1664 x 380 x 1809 mm', 87000);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-SHEL-SHF', (SELECT type_id FROM item_types WHERE name = 'Shelf'), 'Songdream Shel Shelf Unit Natural Walnut', '374 mm', 28960);
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('SD-NUM-ST', (SELECT type_id FROM item_types WHERE name = 'Center Table'), 'Songdream Num Side Table Black Oak', 8050);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-NORD-SOF', (SELECT type_id FROM item_types WHERE name = 'Sofa'), 'Songdream Nord Two Seater Sofa', '360 mm', 108800);
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('SD-MOCH-ST', (SELECT type_id FROM item_types WHERE name = 'Center Table'), 'Songdream Mocha Side Table Mustard', 15750);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('SD-IRIS-SOF', (SELECT type_id FROM item_types WHERE name = 'Sofa'), 'Songdream Iris Three Seater Sofa', '400 mm', 94000);
INSERT INTO items (item_code, type_id, item_name, srp) VALUES ('SD-FLEX-SOF', (SELECT type_id FROM item_types WHERE name = 'Furniture'), 'Songdream Flex', 132000);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('LUM-WRIN-PLG', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Lumenis Wring 3S Pendant Lamp Gold', '60 x 60 x 120 cm', 21760);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('LUM-MICA-PLC2', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Lumenis Mica 20B Coffee Pendant Lamp', '700 x 1500 mm', 38325);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('LUM-MICA-PLC1', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Lumenis Mica 12 Pendant Lamp Coffee', '1200 x 110 x 1200 mm', 27370);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('LUM-SHOT-PLC2', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Lumenis Shot 21 Pendant Lamp Coffee', '550 x 550 x 3000 mm', 38150);
INSERT INTO items (item_code, type_id, item_name, dimension, srp) VALUES ('LUM-SHOT-PLC1', (SELECT type_id FROM item_types WHERE name = 'Lamp'), 'Lumenis Shot 12 Pendant Lamp Coffee', '1200 x 580 x 1500 mm', 25373);

-- 7. LOGISTICS ENTITIES
INSERT INTO suppliers (name, email, supplier_code) VALUES ('Songdream Manufacturing HQ', 'b2b@songdream.com', 'SUP-SD-01');
INSERT INTO suppliers (name, email, supplier_code) VALUES ('Nordlux Nordic Group', 'export@nordlux.dk', 'SUP-NL-02');
INSERT INTO suppliers (name, email, supplier_code) VALUES ('Totguard Kids Furniture Corp', 'orders@totguard.tw', 'SUP-TG-03');

INSERT INTO locations (name, type, city, location_code) VALUES ('Warehouse', 'Warehouse', 'Antipolo City', 'LOC-WHS-01');
INSERT INTO locations (name, type, city, location_code) VALUES ('My Mchome Palazzo 3F', 'Showroom', 'Taguig City', 'LOC-BGC-01');

-- 8. INVENTORY (FULL RESTORATION - 62 ROWS)
-- Main Warehouse (Default)
INSERT INTO MAXXBRANDS.inventory (item_id, location_id, qty_on_hand, min_threshold)
SELECT item_id, (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'), 80, 10 
FROM MAXXBRANDS.items;

-- BGC Showroom
INSERT INTO MAXXBRANDS.inventory (item_id, location_id, qty_on_hand, min_threshold)
SELECT item_id, (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-BGC-01'), 12, 5 
FROM MAXXBRANDS.items;

-- Targeted Low Stock for Testing Reorder Logic (Warehouse)
UPDATE MAXXBRANDS.inventory 
SET qty_on_hand = 3 
WHERE location_id = (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01')
AND item_id IN (SELECT item_id FROM MAXXBRANDS.items WHERE item_code IN ('SD-SHIBA-TVS', 'SD-ALFA-CT', 'HD-RAMP-TL'));

-- 9. PROCUREMENT (3 POs + BULK LINES)
INSERT INTO MAXXBRANDS.purchase_orders (po_number, supplier_id, requested_by, order_date, status, location_id, approved_by, approval_date, payment_terms, due_date) VALUES 
('PO-2026-001', (SELECT supplier_id FROM MAXXBRANDS.suppliers WHERE supplier_code = 'SUP-SD-01'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'jerick.remo@maxxbrands.com'), DATE'2026-04-01', 'Approved', (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'), 
 (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'peter.delacruz@maxxbrands.com'), TIMESTAMP'2026-04-01 10:30:00', 'Net 30', DATE'2026-04-30');

INSERT INTO MAXXBRANDS.purchase_orders (po_number, supplier_id, requested_by, order_date, status, location_id, approved_by, approval_date, payment_terms, due_date) VALUES 
('PO-2026-002', (SELECT supplier_id FROM MAXXBRANDS.suppliers WHERE supplier_code = 'SUP-NL-02'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'jerick.remo@maxxbrands.com'), DATE'2026-04-05', 'Pending', (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'), 
 (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'peter.delacruz@maxxbrands.com'), TIMESTAMP'2026-04-06 09:15:00', 'Net 30', DATE'2026-05-05');

INSERT INTO MAXXBRANDS.purchase_orders (po_number, supplier_id, requested_by, order_date, status, location_id, approved_by, approval_date, payment_terms, due_date) VALUES 
('PO-2026-003', (SELECT supplier_id FROM MAXXBRANDS.suppliers WHERE supplier_code = 'SUP-TG-03'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'jerick.remo@maxxbrands.com'), DATE'2026-04-10', 'Delivered', (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'), 
 (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'peter.delacruz@maxxbrands.com'), TIMESTAMP'2026-04-10 16:45:00', 'Net 30', DATE'2026-05-10');

-- Bulk PO Lines
INSERT INTO MAXXBRANDS.purchase_order_lines (po_id, item_id, suggested_qty, unit_cost, line_total) VALUES ((SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-001'), (SELECT item_id FROM MAXXBRANDS.items WHERE item_code = 'SD-SHIBA-TVS'), 50, 15400, 770000);
INSERT INTO MAXXBRANDS.purchase_order_lines (po_id, item_id, suggested_qty, unit_cost, line_total) VALUES ((SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-001'), (SELECT item_id FROM MAXXBRANDS.items WHERE item_code = 'SD-ALFA-CT'), 40, 8540, 341600);
INSERT INTO MAXXBRANDS.purchase_order_lines (po_id, item_id, suggested_qty, unit_cost, line_total) SELECT (SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-002'), item_id, 10, 5000, 50000 FROM MAXXBRANDS.items WHERE item_code LIKE 'HD-%';
INSERT INTO MAXXBRANDS.purchase_order_lines (po_id, item_id, suggested_qty, unit_cost, line_total) SELECT (SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-003'), item_id, 20, 12000, 240000 FROM MAXXBRANDS.items WHERE item_code LIKE 'IS-%';

-- 10. SALES & CUSTOMERS
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Ayala Land Inc.', 'procurement@ayalaland.com.ph');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Walk-in Retail', 'walkin.retail@com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('SM Prime Holdings', 'purchasing@smprime.com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Megaworld Corp', 'logistics@megaworld.com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('John Doe', 'johndoe@gmail.com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Jane Smith', 'jane.smith@gmail.com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Rockwell Land', 'procurement@rockwell.com.ph');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Federal Land', 'fed.procurement@fedland.com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Shang Properties', 'shang.logistics@shang.com');
INSERT INTO MAXXBRANDS.customers (name, email) VALUES ('Vista Land', 'vlad.procurement@vistaland.com.ph');

INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260301', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Ayala Land Inc.'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-02 10:30:00', 581000, 'Full Payment', DATE'2026-04-02');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('POS-BGC-001', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Walk-in Retail'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'kurt.raneses@maxxbrands.com'), TIMESTAMP'2026-04-02 14:15:00', 28560, 'Full Payment', DATE'2026-04-02');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260305', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'SM Prime Holdings'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-05 11:00:00', 597670, 'Full Payment', DATE'2026-04-05');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260308', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Megaworld Corp'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-08 09:00:00', 120000, 'Full Payment', DATE'2026-04-08');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('POS-BGC-002', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'John Doe'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'kurt.raneses@maxxbrands.com'), TIMESTAMP'2026-04-09 16:30:00', 15000, 'Full Payment', DATE'2026-04-09');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260310', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Rockwell Land'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-10 10:00:00', 450000, 'Full Payment', DATE'2026-04-10');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260312', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Federal Land'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-12 14:00:00', 310000, 'Full Payment', DATE'2026-04-12');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('POS-BGC-003', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Jane Smith'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'kurt.raneses@maxxbrands.com'), TIMESTAMP'2026-04-14 11:30:00', 9000, 'Full Payment', DATE'2026-04-14');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260315', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Shang Properties'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-15 09:15:00', 220000, 'Full Payment', DATE'2026-04-15');
INSERT INTO MAXXBRANDS.sales (sap_ref_no, customer_id, processed_by, sale_date, total_amount, payment_terms, due_date) VALUES ('SAP-INV-260318', (SELECT customer_id FROM MAXXBRANDS.customers WHERE name = 'Vista Land'), (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-16 01:45:00', 880000, 'Full Payment', DATE'2026-04-16');

-- Bulk Sales Items
INSERT INTO MAXXBRANDS.sales_items (sale_id, item_id, qty, unit_price, line_total, allocation_status) VALUES ((SELECT sale_id FROM MAXXBRANDS.sales WHERE sap_ref_no = 'SAP-INV-260301'), (SELECT item_id FROM MAXXBRANDS.items WHERE item_code = 'SD-SHIBA-TVS'), 5, 30800, 154000, 'RELEASED');
INSERT INTO MAXXBRANDS.sales_items (sale_id, item_id, qty, unit_price, line_total, allocation_status) VALUES ((SELECT sale_id FROM MAXXBRANDS.sales WHERE sap_ref_no = 'SAP-INV-260301'), (SELECT item_id FROM MAXXBRANDS.items WHERE item_code = 'SD-ALFA-CT'), 5, 17080, 85400, 'RELEASED');
INSERT INTO MAXXBRANDS.sales_items (sale_id, item_id, qty, unit_price, line_total, allocation_status) SELECT (SELECT sale_id FROM MAXXBRANDS.sales WHERE sap_ref_no = 'SAP-INV-260318'), item_id, 1, srp, srp, 'RELEASED' FROM MAXXBRANDS.items WHERE item_code IN ('SD-NORD-SOF', 'SD-IRIS-SOF', 'SD-FLEX-SOF');

-- 11. ATTENDANCE (April)
INSERT INTO MAXXBRANDS.attendance (employee_id, work_date, time_in, time_out, status) VALUES ((SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'peter.delacruz@maxxbrands.com'), DATE'2026-04-02', TIMESTAMP'2026-04-02 08:00:00', TIMESTAMP'2026-04-02 17:00:00', 'On-Time');
INSERT INTO MAXXBRANDS.attendance (employee_id, work_date, time_in, time_out, status) VALUES ((SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), DATE'2026-04-02', TIMESTAMP'2026-04-02 08:15:00', TIMESTAMP'2026-04-02 17:15:00', 'Late');
INSERT INTO MAXXBRANDS.attendance (employee_id, work_date, time_in, time_out, status) VALUES ((SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'kurt.raneses@maxxbrands.com'), DATE'2026-04-02', TIMESTAMP'2026-04-02 07:55:00', TIMESTAMP'2026-04-02 16:55:00', 'On-Time');
INSERT INTO MAXXBRANDS.attendance (employee_id, work_date, time_in, time_out, status) VALUES ((SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'jerick.remo@maxxbrands.com'), DATE'2026-04-02', TIMESTAMP'2026-04-02 08:00:00', TIMESTAMP'2026-04-02 17:00:00', 'On-Time');
INSERT INTO MAXXBRANDS.attendance (employee_id, work_date, time_in, time_out, status) VALUES ((SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'sean.coquia@maxxbrands.com'), DATE'2026-04-02', TIMESTAMP'2026-04-02 08:00:00', TIMESTAMP'2026-04-02 17:00:00', 'On-Time');

-- 12. PROCUREMENT TRACKING & RECEIPTS
INSERT INTO MAXXBRANDS.purchases (po_id, received_by, received_date, status) VALUES 
((SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-003'), 
 (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'jerick.remo@maxxbrands.com'), 
 TIMESTAMP'2026-04-12 10:00:00', 'Full Delivery');

INSERT INTO MAXXBRANDS.po_tracking (po_id, milestone, location, update_time, logged_by) VALUES 
((SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-001'), 'Order Confirmed', 'Songdream HQ', TIMESTAMP'2026-04-01 11:00:00', (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'peter.delacruz@maxxbrands.com'));
INSERT INTO MAXXBRANDS.po_tracking (po_id, milestone, location, update_time, logged_by) VALUES 
((SELECT po_id FROM MAXXBRANDS.purchase_orders WHERE po_number = 'PO-2026-003'), 'In Transit', 'Manila Port', TIMESTAMP'2026-04-11 14:00:00', (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'sean.coquia@maxxbrands.com'));

-- 13. FULFILLMENTS
INSERT INTO MAXXBRANDS.fulfillments (sale_id, method, status, target_date, actual_completion_date, handled_by) VALUES 
((SELECT sale_id FROM MAXXBRANDS.sales WHERE sap_ref_no = 'SAP-INV-260301'), 'Truck Delivery', 'COMPLETED', DATE'2026-04-05', TIMESTAMP'2026-04-05 15:00:00', (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'sean.coquia@maxxbrands.com'));
INSERT INTO MAXXBRANDS.fulfillments (sale_id, method, status, target_date, actual_completion_date, handled_by) VALUES 
((SELECT sale_id FROM MAXXBRANDS.sales WHERE sap_ref_no = 'POS-BGC-001'), 'Pick-up', 'COMPLETED', DATE'2026-04-02', TIMESTAMP'2026-04-02 16:30:00', (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'kurt.raneses@maxxbrands.com'));

-- 14. EXTENSION MODULES (Supplier Prices, Payments, Alerts, Audits)
INSERT INTO MAXXBRANDS.supplier_item_prices (supplier_id, item_id, unit_cost, lead_time_days, effective_date) VALUES
((SELECT supplier_id FROM MAXXBRANDS.suppliers WHERE supplier_code = 'SUP-SD-01'), (SELECT item_id FROM MAXXBRANDS.items WHERE item_code = 'SD-SHIBA-TVS'), 15000, 30, DATE'2026-01-01');

INSERT INTO MAXXBRANDS.payments (related_type, related_id, amount, payment_method, reference_no, logged_by, payment_date) VALUES
('SALE', (SELECT sale_id FROM MAXXBRANDS.sales WHERE sap_ref_no = 'SAP-INV-260301'), 581000, 'Bank Transfer', 'REF-PYMT-001', (SELECT employee_id FROM MAXXBRANDS.employees WHERE email = 'hanz.mapua@maxxbrands.com'), TIMESTAMP'2026-04-02 11:30:00');

INSERT INTO MAXXBRANDS.reorder_alerts (item_id, location_id, current_qty, threshold_qty, status, alert_date) VALUES
((SELECT item_id FROM MAXXBRANDS.items WHERE item_code = 'SD-SHIBA-TVS'), (SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'), 3, 3, 'ACTIVE', TIMESTAMP'2026-04-01 08:30:00');

INSERT INTO MAXXBRANDS.audit_logs (user_id, action_type, log_timestamp, log_details) VALUES
((SELECT user_id FROM MAXXBRANDS.users WHERE username = 'admin_peter'), 'INVENTORY_ADJUSTMENT', TIMESTAMP'2026-04-02 11:00:00', 'Stock replenishment confirmed for SD-SHIBA-TVS via PO-2026-001');

COMMIT;
