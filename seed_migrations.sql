-- ==========================================
-- MAXXBRANDS ERP: SEED BACKFILL
-- Phase 1: Advanced Reporting Layer
-- Purpose: Populate tax and shipping for historical data
-- ==========================================

-- Backfill Tax and Shipping for existing sales
-- 1. Net Revenue = total_amount / 1.12
-- 2. Tax Amount = total_amount - (total_amount / 1.12)
-- 3. Shipping = 0 (Conservative estimate)

UPDATE MAXXBRANDS.sales
SET tax_amount = ROUND(total_amount - (total_amount / 1.12), 2),
    shipping_amount = 0
WHERE tax_amount = 0 OR tax_amount IS NULL;

COMMIT;
