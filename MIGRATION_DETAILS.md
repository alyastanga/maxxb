# Maxxbrands ERP Migration Tracking

This document tracks all incremental database migrations and schema updates performed on the Maxxbrands ERP system.

## Migration History

| Version | Phase | Title | File Reference | Date | Description |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **V1.0** | Phase 1 | **Advanced Reporting Layer** | [migrations.sql](migrations.sql) | 2026-04-25 | Added `tax_amount` and `shipping_amount` columns to the `sales` table. |
| **V1.1** | Phase 1 | **Reporting Backfill** | [seed_migrations.sql](seed_migrations.sql) | 2026-04-25 | Populated `tax_amount` (VAT calculation) and `shipping_amount` for historical sales data. |
| **V2.0** | Phase 3 | **Global System Resilience** | [migrations_v2.sql](migrations_v2.sql) | 2026-04-25 | Introduced `is_default` flag for locations, set 'Warehouse' as default, and enforced single-default logic via unique index. |

---

## Detailed Migration Specifications

### [V1.0] Advanced Reporting Layer
*   **Target Table:** `MAXXBRANDS.sales`
*   **Changes:**
    *   Added `tax_amount NUMBER(12,2) DEFAULT 0`
    *   Added `shipping_amount NUMBER(12,2) DEFAULT 0`
*   **Purpose:** To support detailed financial analytics and net revenue reporting.

### [V1.1] Reporting Backfill
*   **Logic:** 
    *   Tax = `total_amount - (total_amount / 1.12)`
    *   Shipping = `0` (conservative estimate for legacy data)
*   **Scope:** All sales where `tax_amount` was currently 0 or NULL.

### [V2.0] Global System Resilience
*   **Target Table:** `MAXXBRANDS.locations`
*   **Changes:**
    *   Added `is_default CHAR(1) DEFAULT 'N'`
    *   Enforced domain: `CHECK (is_default IN ('Y', 'N'))`
    *   Data Update: Set `LOC-WHS-01` as primary.
    *   Logic Constraint: Added `idx_only_one_default_location` unique index using a function-based approach.
*   **Purpose:** To allow the system to automatically resolve inventory targets for procurement and transfers without manual location selection.

---

## Pending / Future Migrations
*   [ ] Inventory Transfer Module (Phase 4)
*   [ ] Batch/Lot Tracking Extensions
*   [ ] Multi-currency Support enhancements
