# Phase 3: Global System Resilience - Research

Research into robust configuration patterns for Oracle 23ai ERP systems.

## 1. Dynamic Location Resolution

The goal is to remove `LOC-WHS-01` hardcoding.

### Pattern: `is_default` flag with Filtered Unique Index
- **Schema**: `ALTER TABLE locations ADD (is_default CHAR(1) DEFAULT 'N' CHECK (is_default IN ('Y', 'N')));`
- **Integrity**: To ensure ONLY ONE location is the default, we will use a **Partial Unique Index**.
- **Index Definition**: `CREATE UNIQUE INDEX idx_default_location ON locations (CASE WHEN is_default = 'Y' THEN 1 ELSE NULL END);`
- **Benefit**: This enforces the "Single Warehouse" rule at the database level, preventing accidental config errors where two warehouses are both marked defaults.

## 2. Centralized Parameter Access

To avoid repeating the subquery `SELECT location_id FROM locations WHERE is_default = 'Y'` in every trigger:

### Pattern: `PKG_CORE` Singleton
- **Implementation**: A PL/SQL package with a cached variable.
- **Function**: `PKG_CORE.GET_DEFAULT_LOCATION`
- **Optimization**: Use `RESULT_CACHE` on the function (Oracle 23ai feature) to ensure that the ID lookup happens only once per session or until the `locations` table changes.

## 3. High-Integrity User Resolution

Currently, audit triggers use `MIN(user_id)`.

### Pattern: `SYS_CONTEXT` or `PKG_SESSION`
- **Proposal**: Create a `PKG_SESSION` package that the UI/middleware can use to set the `current_user_id` at the start of a connection.
- **Fallback**: If not set, default to a 'SYSTEM' user ID.

---

*Verified: April 2026*
