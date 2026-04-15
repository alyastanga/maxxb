# Phase 4: Full System UAT - Execution Plan

Comprehensive validation of the Maxxbrands ERP automation and reporting layers using the finalized 62-row seed dataset.

## Goal
Verify that all system requirements are met, technically resilient, and ready for production handover.

## Integration Tests

### [Test Suite 1] Procurement Automation
Validate that the "Threshold -> Alert -> PO" loop is batched and idempotent.

#### 1.1 Single-Item Alert
```sql
UPDATE inventory SET qty_on_hand = 5 WHERE item_id = 1 AND location_id = (SELECT PKG_CORE.GET_DEFAULT_LOCATION_ID FROM DUAL);
-- Expected: 1 ACTIVE reorder_alert, 1 PENDING PO with 'AUTO-PO' number.
```

#### 1.2 Batching & Idempotency
```sql
UPDATE inventory SET qty_on_hand = 5 WHERE item_id = 2 AND location_id = (SELECT PKG_CORE.GET_DEFAULT_LOCATION_ID FROM DUAL);
-- Expected: New alert created, but line appends to the EXISTING PENDING PO (no new PO header).
```

### [Test Suite 2] Analytical Views
Verify the accuracy of the executive and logistics insight layers.

#### 2.1 Dashboard KPI Verification
- Query `vw_executive_dashboard`.
- Manually calculate one revenue figure from `sales` to verify the view logic.

#### 2.2 Sales Velocity & Stockouts
- Query `vw_sales_velocity`.
- Verify the "Days of Stock Remaining" calculation against current `inventory.qty_on_hand`.

### [Test Suite 3] System Resilience
Verify the "Zero-Code" maintenance requirement.

#### 3.1 Default Location Migration
- MARK a different location as `is_default = 'Y'`.
- Run a stock update and verify `PKG_CORE` correctly routes automation logic to the new location without code changes.

## Verification Checklist

- [ ] All 62 seed rows load without errors.
- [ ] ORA-04091 Mutation errors: 0.
- [ ] Duplicate Pending POs for same supplier: 0.
- [ ] PKG_CORE correctly cached for performance.
