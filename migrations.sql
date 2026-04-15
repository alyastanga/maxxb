-- ==========================================
-- MAXXBRANDS ERP: INCREMENTAL MIGRATIONS
-- Phase 1: Advanced Reporting Layer
-- ==========================================

-- Add Reporting Columns to Sales
ALTER TABLE MAXXBRANDS.sales ADD (tax_amount NUMBER(12,2) DEFAULT 0);
ALTER TABLE MAXXBRANDS.sales ADD (shipping_amount NUMBER(12,2) DEFAULT 0);

COMMIT;
