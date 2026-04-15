-- ==========================================
-- PERFORMANCE OPTIMIZATION (INDEXES)
-- ==========================================

-- 1. Inventory & Catalog Lookups
CREATE INDEX MAXXBRANDS.idx_inv_item ON MAXXBRANDS.inventory(item_id);
CREATE INDEX MAXXBRANDS.idx_inv_loc ON MAXXBRANDS.inventory(location_id);
CREATE INDEX MAXXBRANDS.idx_itm_code ON MAXXBRANDS.items(item_code);
CREATE INDEX MAXXBRANDS.idx_itm_type ON MAXXBRANDS.items(type_id);

-- 2. Procurement Tracking
CREATE INDEX MAXXBRANDS.idx_po_number ON MAXXBRANDS.purchase_orders(po_number);
CREATE INDEX MAXXBRANDS.idx_po_status ON MAXXBRANDS.purchase_orders(status);
CREATE INDEX MAXXBRANDS.idx_po_supp ON MAXXBRANDS.purchase_orders(supplier_id);

-- 3. Sales & Fulfillment
CREATE INDEX MAXXBRANDS.idx_sales_sap ON MAXXBRANDS.sales(sap_ref_no);
CREATE INDEX MAXXBRANDS.idx_sales_cust ON MAXXBRANDS.sales(customer_id);
CREATE INDEX MAXXBRANDS.idx_ful_status ON MAXXBRANDS.fulfillments(status);
CREATE INDEX MAXXBRANDS.idx_ful_target ON MAXXBRANDS.fulfillments(target_date);

-- 4. Audit & Logging
CREATE INDEX MAXXBRANDS.idx_audit_time ON MAXXBRANDS.audit_logs(log_timestamp);
CREATE INDEX MAXXBRANDS.idx_audit_type ON MAXXBRANDS.audit_logs(action_type);

COMMIT;
