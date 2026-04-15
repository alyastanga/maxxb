-- ==========================================
-- MAXXBRANDS ERP DATABASE SCHEMA
-- Target: Oracle 23ai
-- ==========================================

-- 1. Standard Lookup Tables
CREATE TABLE MAXXBRANDS.roles (
  role_id NUMBER DEFAULT MAXXBRANDS.seq_role_id.NEXTVAL PRIMARY KEY,
  name VARCHAR2(100) NOT NULL UNIQUE
);

CREATE TABLE MAXXBRANDS.employees (
  employee_id NUMBER DEFAULT MAXXBRANDS.seq_employee_id.NEXTVAL PRIMARY KEY,
  role_id NUMBER NOT NULL,
  first_name VARCHAR2(100) NOT NULL,
  last_name VARCHAR2(100) NOT NULL,
  hire_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  email VARCHAR2(150) UNIQUE,
  CONSTRAINT fk_emp_role FOREIGN KEY (role_id) REFERENCES MAXXBRANDS.roles(role_id)
);

CREATE TABLE MAXXBRANDS.users (
  user_id NUMBER DEFAULT MAXXBRANDS.seq_user_id.NEXTVAL PRIMARY KEY,
  employee_id NUMBER UNIQUE NOT NULL,
  username VARCHAR2(50) NOT NULL UNIQUE,
  password_hash VARCHAR2(255) NOT NULL,
  CONSTRAINT fk_usr_emp FOREIGN KEY (employee_id) REFERENCES MAXXBRANDS.employees(employee_id)
);

CREATE TABLE MAXXBRANDS.attendance (
  attendance_id NUMBER DEFAULT MAXXBRANDS.seq_attendance_id.NEXTVAL PRIMARY KEY,
  employee_id NUMBER NOT NULL,
  work_date DATE NOT NULL, 
  time_in TIMESTAMP NOT NULL, 
  time_out TIMESTAMP,
  status VARCHAR2(50) CHECK (status IN ('On-Time', 'Late', 'Absent', 'Leave')),
  CONSTRAINT fk_att_emp FOREIGN KEY (employee_id) REFERENCES MAXXBRANDS.employees(employee_id)
);

-- 2. Catalog Tables
CREATE TABLE MAXXBRANDS.categories (
  category_id NUMBER DEFAULT MAXXBRANDS.seq_category_id.NEXTVAL PRIMARY KEY,
  name VARCHAR2(100) NOT NULL UNIQUE
);

CREATE TABLE MAXXBRANDS.item_types (
  type_id NUMBER DEFAULT MAXXBRANDS.seq_type_id.NEXTVAL PRIMARY KEY,
  category_id NUMBER NOT NULL,
  name VARCHAR2(100) NOT NULL UNIQUE,
  CONSTRAINT fk_typ_cat FOREIGN KEY (category_id) REFERENCES MAXXBRANDS.categories(category_id)
);

CREATE TABLE MAXXBRANDS.items (
  item_id NUMBER DEFAULT MAXXBRANDS.seq_item_id.NEXTVAL PRIMARY KEY,
  item_code VARCHAR2(50) NOT NULL UNIQUE,
  type_id NUMBER NOT NULL,
  item_name VARCHAR2(150) NOT NULL UNIQUE,
  dimension VARCHAR2(100) DEFAULT NULL,
  srp NUMBER(10,2) NOT NULL CHECK (srp >= 0),
  CONSTRAINT fk_itm_typ FOREIGN KEY (type_id) REFERENCES MAXXBRANDS.item_types(type_id)
);

CREATE TABLE MAXXBRANDS.item_attributes (
  attribute_id NUMBER DEFAULT MAXXBRANDS.seq_attribute_id.NEXTVAL PRIMARY KEY,
  item_id NUMBER NOT NULL,
  material VARCHAR2(100),
  fabric_color VARCHAR2(100),
  leg_color VARCHAR2(100),
  CONSTRAINT fk_att_itm FOREIGN KEY (item_id) REFERENCES MAXXBRANDS.items(item_id)
);

-- 3. Logistics & Inventory
CREATE TABLE MAXXBRANDS.suppliers (
  supplier_id NUMBER DEFAULT MAXXBRANDS.seq_supplier_id.NEXTVAL PRIMARY KEY,
  name VARCHAR2(150) NOT NULL,
  contact_no VARCHAR2(50),
  email VARCHAR2(100),
  address VARCHAR2(255),
  supplier_code VARCHAR2(50) UNIQUE
);

CREATE TABLE MAXXBRANDS.locations (
  location_id NUMBER DEFAULT MAXXBRANDS.seq_location_id.NEXTVAL PRIMARY KEY,
  name VARCHAR2(150) NOT NULL,
  type VARCHAR2(50) NOT NULL, 
  street VARCHAR2(100), 
  barangay VARCHAR2(50), 
  city VARCHAR2(50),
  location_code VARCHAR2(50) UNIQUE
);

CREATE TABLE MAXXBRANDS.inventory (
  inventory_id NUMBER DEFAULT MAXXBRANDS.seq_inventory_id.NEXTVAL PRIMARY KEY,
  item_id NUMBER NOT NULL,
  location_id NUMBER NOT NULL,
  qty_on_hand NUMBER DEFAULT 0 NOT NULL CHECK (qty_on_hand >= 0),
  min_threshold NUMBER DEFAULT 0 NOT NULL CHECK (min_threshold >= 0),
  CONSTRAINT fk_inv_itm FOREIGN KEY (item_id) REFERENCES MAXXBRANDS.items(item_id),
  CONSTRAINT fk_inv_loc FOREIGN KEY (location_id) REFERENCES MAXXBRANDS.locations(location_id)
);

-- 4. Procurement
CREATE TABLE MAXXBRANDS.purchase_orders (
  po_id NUMBER DEFAULT MAXXBRANDS.seq_po_id.NEXTVAL PRIMARY KEY,
  po_number VARCHAR2(50) UNIQUE,
  supplier_id NUMBER NOT NULL,
  requested_by NUMBER NOT NULL,
  order_date DATE NOT NULL,
  status VARCHAR2(50) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'In Transit', 'Delivered', 'Cancelled')),
  total_po_amount NUMBER(12,2) DEFAULT 0 CHECK (total_po_amount >= 0),
  currency VARCHAR2(10) DEFAULT 'PHP',
  location_id NUMBER NOT NULL,
  approved_by NUMBER,
  approval_date TIMESTAMP,
  payment_terms VARCHAR2(100),
  due_date DATE,
  CONSTRAINT fk_po_sup FOREIGN KEY (supplier_id) REFERENCES MAXXBRANDS.suppliers(supplier_id),
  CONSTRAINT fk_po_emp FOREIGN KEY (requested_by) REFERENCES MAXXBRANDS.employees(employee_id),
  CONSTRAINT fk_po_loc FOREIGN KEY (location_id) REFERENCES MAXXBRANDS.locations(location_id)
);

CREATE TABLE MAXXBRANDS.purchase_order_lines (
  po_line_id NUMBER DEFAULT MAXXBRANDS.seq_po_line_id.NEXTVAL PRIMARY KEY,
  po_id NUMBER NOT NULL,
  item_id NUMBER NOT NULL,
  suggested_qty NUMBER NOT NULL CHECK (suggested_qty > 0),
  unit_cost NUMBER(10,2) NOT NULL CHECK (unit_cost >= 0),
  line_total NUMBER(12,2) NOT NULL CHECK (line_total >= 0),
  qty_received NUMBER DEFAULT 0 CHECK (qty_received >= 0),
  CONSTRAINT fk_pol_po FOREIGN KEY (po_id) REFERENCES MAXXBRANDS.purchase_orders(po_id),
  CONSTRAINT fk_pol_itm FOREIGN KEY (item_id) REFERENCES MAXXBRANDS.items(item_id)
);

CREATE TABLE MAXXBRANDS.purchases (
  purchase_id NUMBER DEFAULT MAXXBRANDS.seq_purchase_id.NEXTVAL PRIMARY KEY,
  po_id NUMBER NOT NULL,
  received_by NUMBER NOT NULL,
  received_date TIMESTAMP NOT NULL,
  status VARCHAR2(50) CHECK (status IN ('Partial Delivery', 'Full Delivery')),
  CONSTRAINT fk_pur_po FOREIGN KEY (po_id) REFERENCES MAXXBRANDS.purchase_orders(po_id),
  CONSTRAINT fk_pur_emp FOREIGN KEY (received_by) REFERENCES MAXXBRANDS.employees(employee_id)
);

CREATE TABLE MAXXBRANDS.po_tracking (
  tracking_id NUMBER DEFAULT MAXXBRANDS.seq_tracking_id.NEXTVAL PRIMARY KEY,
  po_id NUMBER NOT NULL,
  milestone VARCHAR2(100) NOT NULL,
  location VARCHAR2(150),
  update_time TIMESTAMP NOT NULL,
  logged_by NUMBER NOT NULL,
  CONSTRAINT fk_trk_po FOREIGN KEY (po_id) REFERENCES MAXXBRANDS.purchase_orders(po_id),
  CONSTRAINT fk_trk_emp FOREIGN KEY (logged_by) REFERENCES MAXXBRANDS.employees(employee_id)
);

-- 5. Sales & Customers
CREATE TABLE MAXXBRANDS.customers (
  customer_id NUMBER DEFAULT MAXXBRANDS.seq_customer_id.NEXTVAL PRIMARY KEY,
  name VARCHAR2(150) NOT NULL,
  contact_no VARCHAR2(50),
  email VARCHAR2(100),
  project_location VARCHAR2(255)
);

CREATE TABLE MAXXBRANDS.sales (
  sale_id NUMBER DEFAULT MAXXBRANDS.seq_sale_id.NEXTVAL PRIMARY KEY,
  sap_ref_no VARCHAR2(100) UNIQUE,
  customer_id NUMBER NOT NULL,
  processed_by NUMBER NOT NULL,
  sale_date TIMESTAMP NOT NULL,
  total_amount NUMBER(12,2) DEFAULT 0 CHECK (total_amount >= 0),
  payment_terms VARCHAR2(50),
  due_date DATE,
  CONSTRAINT fk_sal_cus FOREIGN KEY (customer_id) REFERENCES MAXXBRANDS.customers(customer_id),
  CONSTRAINT fk_sal_emp FOREIGN KEY (processed_by) REFERENCES MAXXBRANDS.employees(employee_id)
);

CREATE TABLE MAXXBRANDS.sales_items (
  sale_item_id NUMBER DEFAULT MAXXBRANDS.seq_sale_item_id.NEXTVAL PRIMARY KEY,
  sale_id NUMBER NOT NULL,
  item_id NUMBER NOT NULL,
  qty NUMBER NOT NULL CHECK (qty > 0),
  unit_price NUMBER(10,2) NOT NULL CHECK (unit_price >= 0),
  line_total NUMBER(12,2) NOT NULL CHECK (line_total >= 0),
  allocation_status VARCHAR2(50) CHECK (allocation_status IN ('ALLOCATED', 'RELEASED', 'BACKORDERED')),
  CONSTRAINT fk_sit_sal FOREIGN KEY (sale_id) REFERENCES MAXXBRANDS.sales(sale_id),
  CONSTRAINT fk_sit_itm FOREIGN KEY (item_id) REFERENCES MAXXBRANDS.items(item_id)
);

CREATE TABLE MAXXBRANDS.fulfillments (
  fulfillment_id NUMBER DEFAULT MAXXBRANDS.seq_fulfillment_id.NEXTVAL PRIMARY KEY,
  sale_id NUMBER NOT NULL,
  method VARCHAR2(50) CHECK (method IN ('Pick-up', 'Truck Delivery', 'Van Delivery')),
  status VARCHAR2(50) DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SCHEDULED', 'IN-TRANSIT', 'COMPLETED', 'FAILED', 'RETURNED', 'PARTIAL')),
  target_date DATE NOT NULL,
  actual_completion_date TIMESTAMP,
  handled_by NUMBER NOT NULL,
  CONSTRAINT fk_ful_sal FOREIGN KEY (sale_id) REFERENCES MAXXBRANDS.sales(sale_id),
  CONSTRAINT fk_ful_emp FOREIGN KEY (handled_by) REFERENCES MAXXBRANDS.employees(employee_id)
);

-- 6. Extension Modules (Approved in Plan)
CREATE TABLE MAXXBRANDS.supplier_item_prices (
  price_id NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  supplier_id NUMBER NOT NULL,
  item_id NUMBER NOT NULL,
  unit_cost NUMBER(10,2) NOT NULL CHECK (unit_cost >= 0),
  lead_time_days NUMBER DEFAULT 0,
  effective_date DATE DEFAULT CURRENT_DATE,
  CONSTRAINT fk_sip_sup FOREIGN KEY (supplier_id) REFERENCES MAXXBRANDS.suppliers(supplier_id),
  CONSTRAINT fk_sip_itm FOREIGN KEY (item_id) REFERENCES MAXXBRANDS.items(item_id),
  CONSTRAINT uq_sup_itm UNIQUE (supplier_id, item_id)
);

CREATE TABLE MAXXBRANDS.payments (
  payment_id NUMBER DEFAULT MAXXBRANDS.seq_payment_id.NEXTVAL PRIMARY KEY,
  related_type VARCHAR2(10) NOT NULL CHECK (related_type IN ('SALE', 'PO')),
  related_id NUMBER NOT NULL,
  amount NUMBER(12,2) NOT NULL CHECK (amount >= 0),
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  payment_method VARCHAR2(50) CHECK (payment_method IN ('Cash', 'Bank Transfer', 'Credit Card', 'Check', 'G-Cash')),
  reference_no VARCHAR2(100),
  logged_by NUMBER NOT NULL,
  CONSTRAINT fk_pay_emp FOREIGN KEY (logged_by) REFERENCES MAXXBRANDS.employees(employee_id)
);

CREATE TABLE MAXXBRANDS.reorder_alerts (
  alert_id NUMBER DEFAULT MAXXBRANDS.seq_alert_id.NEXTVAL PRIMARY KEY,
  item_id NUMBER NOT NULL,
  location_id NUMBER NOT NULL,
  current_qty NUMBER NOT NULL,
  threshold_qty NUMBER NOT NULL,
  alert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR2(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'REVIEWED', 'DISMISSED', 'PO_CREATED')),
  CONSTRAINT fk_alr_itm FOREIGN KEY (item_id) REFERENCES MAXXBRANDS.items(item_id),
  CONSTRAINT fk_alr_loc FOREIGN KEY (location_id) REFERENCES MAXXBRANDS.locations(location_id)
);

CREATE TABLE MAXXBRANDS.audit_logs (
  log_id NUMBER DEFAULT MAXXBRANDS.seq_log_id.NEXTVAL PRIMARY KEY,
  user_id NUMBER NOT NULL,
  action_type VARCHAR2(255) NOT NULL,
  log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  log_details VARCHAR2(4000),
  CONSTRAINT fk_aud_usr FOREIGN KEY (user_id) REFERENCES MAXXBRANDS.users(user_id)
);

COMMIT;
