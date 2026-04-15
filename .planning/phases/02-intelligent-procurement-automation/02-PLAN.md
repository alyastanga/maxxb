---
wave: 1
depends_on: []
files_modified: [PKG_PROCUREMENT.sql, triggers.sql]
autonomous: true
---

# Phase 2: Intelligent Procurement Automation - Execution Plan

Implementing the high-integrity procurement engine for the Maxxbrands ERP.

## Goal
Automate the replenishment cycle by grouping low-stock items into batched, idempotent Purchase Orders using Oracle 23ai Compound Triggers and a specialized procurement package.

## Tasks

<task identifier="task_0" read_first="['maxxbrands.sql', 'seed.sql']">
<action>
Create PKG_PROCUREMENT.sql (Specification and Body) to centralize procurement logic.
1. Define a global collection type for item/location pairs.
2. Implement `REGISTER_REORDER_ALERT` (adds to session collection).
3. Implement `PROCESS_REORDERS` (the "Brain"):
   - Identify Primary Supplier for each item.
   - Search for an existing `Pending` PO with `po_number LIKE 'AUTO-PO-%'` for that Supplier + Location.
   - If found: ADD or UPDATE the line item.
   - If not found: CREATE a new PO with `AUTO-PO-` prefix.
</action>
<acceptance_criteria>
- PKG_PROCUREMENT exists and compiles without errors.
- Any manual Pending PO (without 'AUTO-PO-' prefix) is ignored during the "Search" step.
</acceptance_criteria>
</task>

<task identifier="task_1" read_first="['triggers.sql']">
<action>
Replace the existing MAXXBRANDS.trg_auto_po_on_alert with a COMPOUND TRIGGER on MAXXBRANDS.reorder_alerts.
1. BEFORE STATEMENT: Clear the package collection.
2. AFTER EACH ROW: Register the item/location if status is 'ACTIVE'.
3. AFTER STATEMENT: Call `PKG_PROCUREMENT.PROCESS_REORDERS`.
</action>
<acceptance_criteria>
- triggers.sql is updated with the Compound Trigger.
- The trigger calls the new package methods correctly.
</acceptance_criteria>
</task>

<task identifier="task_2" read_first="['seed.sql']">
<action>
Verify grouped procurement:
1. Trigger 3 reorder alerts for the same supplier in one transaction.
2. Verify exactly one PO is created with 3 lines.
3. Verify audit_logs count.
</action>
<acceptance_criteria>
- No duplicate PO headers for the same batch.
- audit_logs contains entries for the automated generation.
</acceptance_criteria>
</task>

## Verification Plan

### Automated Tests
- Run a simulated multi-item sale that triggers multiple reorder alerts.
- Check `SELECT count(*) FROM purchase_orders WHERE status = 'Pending'` before and after.

### Manual Verification
- Review generated `purchase_order_lines` to ensure `unit_cost` and `line_total` are calculated correctly from the `supplier_item_prices` table.
