# Phase 4: Full System UAT - Context

**Gathered**: 16-Apr-2026
**Status**: Ready for planning

## Objective
Execute a multi-point verification of the Maxxbrands ERP system to ensure all automation and reporting requirements are met, technically sound, and resilient under the restored 60-row seed dataset.

## Primary Test Cases

### 1. Procurement Lifecycle (Objective 1)
- **Scenario A**: Single item drops below threshold. Verify PO header and line creation.
- **Scenario B**: Multiple items for the same supplier drop below threshold in separate transactions. Verify quantity appending to the same "Pending" PO.
- **Scenario C**: Multiple items for the same supplier drop below threshold in a single bulk transaction (e.g., fulfilling a massive sale). Verify mutation-free execution and batching.

### 2. Analytical Integrity (Objective 3)
- **Dashboard Check**: Verify `vw_executive_dashboard` reflects accurate revenue and alert counts.
- **Velocity Check**: Verify `vw_sales_velocity` correctly identifies items with low "Days of Stock Remaining".

### 3. System Resilience (Objective 4)
- **Default Location Swap**: Change the `is_default` flag in `locations` and confirm that triggers immediately prioritize the new location for synchronization and logic.
- **User Resolution**: Confirm all audit logs attribute actions to the System Administrator dynamically via `PKG_CORE`.

## Acceptance Criteria
- [ ] 0 ORA-04091 Mutation errors during bulk operations.
- [ ] NO duplicate "Pending" POs for the same supplier/location combo.
- [ ] `seed.sql` successfully populates all 60+ inventory rows with triggers active.

---
*Verified: April 2026*
