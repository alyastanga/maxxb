# Phase 2: Intelligent Procurement Automation - Context

**Gathered**: 16-Apr-2026
**Status**: Ready for planning

## Phase Boundary

This phase delivers the core procurement automation engine, transitioning the system from manual PO entry to an intelligent, automated reorder system.

## Implementation Decisions

### 1. Idempotent Procurement Logic
- **Scope**: The system will check all `PENDING` purchase orders for a given supplier before creating a new one.
- **Rule**: If a `PENDING` PO exists for the supplier, any new low-stock items will be **appended** as new lines to that PO instead of creating a duplicate order.

### 2. Trigger Timing & Batching
- **Strategy**: **Immediate Statement-Level Batching**.
- **Mechanism**: Use Oracle **Compound Triggers**.
    - `BEFORE STATEMENT`: Initialize a collection of items requiring reorder.
    - `AFTER EACH ROW`: Capture item_id and location_id if stock < threshold.
    - `AFTER STATEMENT`: Call `PKG_PROCUREMENT.PROCESS_REORDERS` to group the captured items by supplier and generate the POs in one pass.

### 3. Approval Authority
- **Authorized Roles**: `Store Manager` and `Warehouse Manager`.
- **Status Flow**: `DRAFT` (Initial) -> `PENDING` (Ready for Approval) -> `APPROVED`.

## Canonical References

- [REQUIREMENTS.md](file:///Users/familyaccount/SQL%20Masters/final/.planning/REQUIREMENTS.md) — Section 4 (Procurement Logic).
- [maxxbrands.sql](file:///Users/familyaccount/SQL%20Masters/final/maxxbrands.sql) — Target tables: `purchase_orders`, `purchase_order_lines`.
- [triggers.sql](file:///Users/familyaccount/SQL%20Masters/final/triggers.sql) — Target for compound triggers.

---

*Phase: 02-intelligent-procurement-automation*
*Context gathered via research and user preferences for standard ERP behavior.*
