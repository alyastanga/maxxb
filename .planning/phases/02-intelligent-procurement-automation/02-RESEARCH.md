# Phase 2: Intelligent Procurement Automation - Research

Research into robust auto-procurement patterns for the Maxxbrands ERP.

## 1. Avoiding the "Mutating Table" Error

The core challenge is updating `purchase_orders` based on stock levels in `inventory` while ensuring the logic remains atomic and performant.

### Pattern: Compound Triggers
- **Constraint**: A standard trigger cannot query the table that triggered it (the "Mutating Table" error).
- **Solution**: Oracle **Compound Triggers** allow us to capture row-level changes into a memory-resident collection (Associative Array) and then process that collection as a single "batch" in the `AFTER STATEMENT` section.
- **Workflow**:
    1. `BEFORE STATEMENT`: Clear the global list of low-stock items.
    2. `AFTER EACH ROW`: Append `item_id` and `location_id` to the list if stock falls below threshold.
    3. `AFTER STATEMENT`: Pass the entire list to `PKG_PROCUREMENT.SYNC_SUPPLIER_REORDERS`.

## 2. Idempotent Batched Processing

To fulfill the "Group by Supplier" and "No Duplicates" requirements:

### Mechanism: Service Layer Package (`PKG_PROCUREMENT`)
- **Step 1: Supplier Lookup** — For each low-stock item, identify the primary supplier (via `supplier_item_prices`).
- **Step 2: Existing PO Discovery** — Query `purchase_orders` for a `PENDING` order with the same `supplier_id` and `location_id`.
- **Step 3: Branching Logic**:
    - **Found**: Add a new row to `purchase_order_lines` (or update qty if already exists) for the existing PO.
    - **Not Found**: Generate a new PO and then add the line.

## 3. High-Fidelity Logging

- **Audit Requirement**: Every automated PO generation must be logged in `audit_logs` with the source transaction ID.
- **Implementation**: The package will use `PRAGMA AUTONOMOUS_TRANSACTION` for logging to ensure audit trails persist even if the main procurement transaction is rolled back (Standard ERP Audit Practice).

---

*Verified: April 2026*
