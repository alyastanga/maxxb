---
wave: 1
depends_on: []
files_modified: [migrations_v2.sql, PKG_CORE.sql, triggers.sql, views.sql, seed.sql]
autonomous: true
---

# Phase 3: Global System Resilience & Seed Restoration - Execution Plan

Normalizing technical debt, refactoring hardcoded references, and restoring seed data integrity.

## Goal
Eliminate hardcoded location IDs and strings from triggers and views, ensuring system-wide resilience, and restore the missing seed data to reach the target of 60+ inventory records.

## Tasks

<task identifier="task_0" read_first="['maxxbrands.sql']">
<action>
Create MAXXBRANDS.migrations_v2.sql and implement:
1. ALTER TABLE MAXXBRANDS.locations ADD (is_default CHAR(1) DEFAULT 'N' CHECK (is_default IN ('Y', 'N')));
2. UPDATE MAXXBRANDS.locations SET is_default = 'Y' WHERE location_code = 'LOC-WHS-01';
3. CREATE UNIQUE INDEX idx_default_location ON MAXXBRANDS.locations (CASE WHEN is_default = 'Y' THEN 1 ELSE NULL END);
</action>
<acceptance_criteria>
- migrations_v2.sql exists and contains the schema changes.
- Only one location can be marked as default.
</acceptance_criteria>
</task>

<task identifier="task_1" read_first="['migrations_v2.sql']">
<action>
Create PKG_CORE.sql (Specification and Body):
1. Implement GET_DEFAULT_LOCATION_ID(): Returns the ID of the 'is_default' location.
2. Implement GET_SYSTEM_USER_ID(): Returns the ID of the 'System Administrator' employee.
</action>
<acceptance_criteria>
- PKG_CORE exist and returns correct IDs based on the new schema.
</acceptance_criteria>
</task>

<task identifier="task_2" read_first="['triggers.sql', 'views.sql', 'PKG_CORE.sql']">
<action>
Refactor triggers.sql and views.sql:
1. Replace all 'LOC-WHS-01' subqueries with MAXXBRANDS.PKG_CORE.GET_DEFAULT_LOCATION_ID().
2. Standardize all trigger user resolutions to use MAXXBRANDS.PKG_CORE.GET_SYSTEM_USER_ID().
</action>
<acceptance_criteria>
- No instances of 'LOC-WHS-01' remain in triggers.sql.
- Code is resilient to location code changes.
</acceptance_criteria>
</task>

<task identifier="task_3" read_first="['seed.sql']">
<action>
Restore seed.sql to full capacity:
1. Explicitly list all 31 items for the Warehouse location in the inventory section.
2. Ensure the Showroom also has the full 31 items.
3. Total inventory rows should be 60+ (some items might be single-location).
4. Remove duplicate Attendance/Fulfillment blocks.
</action>
<acceptance_criteria>
- seed.sql contains 60+ inventory insertion rows.
- File is cleaned of redundant code blocks.
</acceptance_criteria>
</task>

## Verification Plan

### Automated Tests
- Run `SELECT count(*) FROM MAXXBRANDS.inventory` to verify 60+ rows.
- Verify PKG_CORE functions return non-null IDs.

### Manual Verification
- Review the cleaned seed.sql for professional structure.
