---
wave: 1
depends_on: []
files_modified: [migrations.sql, views.sql]
autonomous: true
---

# Phase 1: Advanced Reporting Layer - Execution Plan

Implementing the analytical and reporting layer for the Maxxbrands ERP system using incremental migrations.

## Goal
Establish a robust reporting foundation within `views.sql`, supporting executive decision-making and warehouse operations.

## Tasks

<task identifier="task_0" read_first="['maxxbrands.sql']">
<action>
Create MAXXBRANDS.migrations.sql and implement the following schema changes:
1. ALTER TABLE MAXXBRANDS.sales ADD (tax_amount NUMBER(12,2) DEFAULT 0);
2. ALTER TABLE MAXXBRANDS.sales ADD (shipping_amount NUMBER(12,2) DEFAULT 0);
</action>
<acceptance_criteria>
- migrations.sql exists and contains both ALTER TABLE statements.
- The file uses the MAXXBRANDS schema prefix.
</acceptance_criteria>
</task>

<task identifier="task_1" read_first="['views.sql', 'migrations.sql']">
<action>
Implement the following views in views.sql, replacing any existing definitions:

1. vw_executive_dashboard:
   - Calculate "Net Revenue" as SUM(total_amount - (tax_amount + shipping_amount)).
   - Calculate "Gross Revenue" as SUM(total_amount).
   - All aggregations should use TRUNC(sale_date) = TRUNC(CURRENT_DATE).

2. vw_inventory_master:
   - Refine Status logic: 'EMERGENCY' for qty <= 0, 'CRITICAL' for qty <= threshold, 'LOW' for 20% above threshold, else 'OPTIMAL'.

3. vw_sales_velocity:
   - Use a 30-day window function to calculate daily average sales per SKU.
   - Project "Days Remaining" as CURRENT_QTY / DAILY_VELOCITY.

4. vw_fulfillment_queue:
   - Filter for PENDING, SCHEDULED, and IN-TRANSIT status.
</action>
<acceptance_criteria>
- views.sql contains the updated vw_executive_dashboard with Net/Gross split.
- vw_sales_velocity uses window functions for 30-day trailing averages.
- vw_inventory_master contains the EMERGENCY status logic.
</acceptance_criteria>
</task>

<task identifier="task_2" read_first="['views.sql', 'seed.sql']">
<action>
Perform a syntax and accuracy check:
1. Check for Oracle SQL syntax errors in the new view definitions.
2. Verify that the Dashboard view returns non-null metrics when run against the seed data.
</action>
<acceptance_criteria>
- No ORA- errors when querying the new views.
- Metric values are logically consistent with seed data records.
</acceptance_criteria>
</task>

## Verification Plan

### Automated Tests
- Run `SELECT * FROM MAXXBRANDS.vw_sales_velocity` and verify columns exist.
- Cross-check `vw_executive_dashboard` sums against raw data in `sales`.

### Manual Verification
- Review "Days Remaining" in `vw_sales_velocity` to ensure it correctly projects stock-out dates.
