-- ==========================================
-- MAXXBRANDS ERP: MIGRATION V2
-- Phase 3: Global System Resilience
-- Purpose: Dynamic location resolution
-- ==========================================

-- 1. Add 'is_default' flag to locations
ALTER TABLE MAXXBRANDS.locations 
ADD (is_default CHAR(1) DEFAULT 'N' CHECK (is_default IN ('Y', 'N')));

-- 2. Set 'Warehouse' as the default location
UPDATE MAXXBRANDS.locations 
SET is_default = 'Y' 
WHERE location_code = 'LOC-WHS-01';

-- 3. Enforce 'Single Default Location' via Filtered Unique Index
-- This ensures that only one row in the table can have is_default = 'Y'
CREATE UNIQUE INDEX MAXXBRANDS.idx_only_one_default_location 
ON MAXXBRANDS.locations (CASE WHEN is_default = 'Y' THEN 'PRIMARY' ELSE NULL END);

COMMIT;
