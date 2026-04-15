# Research: Tech Stack - Maxxbrands ERP

Detailed investigation into the optimal technology patterns for the Maxxbrands ERP refinement.

## Core Runtime: Oracle 23ai

The system is optimized for Oracle 23ai, leveraging high-performance SQL and PL/SQL features.

### Advanced Trigger Patterns
- **Compound Triggers**: Essential for "Batched Auto-PO" logic. They allow maintaining a state (collection of items) across row-level events and performing a single batched `INSERT` at the statement level. This solves the "Mutating Table" error and reduces transaction overhead.
- **`WHEN` Clauses**: Every trigger should use a declarative `WHEN` clause (e.g., `WHEN (NEW.qty_on_hand <= NEW.min_threshold)`) to avoid firing PL/SQL code for non-critical updates.

### Idempotency & Data Integrity
- **`MERGE` Statements**: Preferred over `INSERT` for automated PO line creation. This ensures that if the trigger runs twice (e.g., due to a retry), it won't duplicate items in an existing "Pending" PO.
- **Unique Constraints**: A composite unique constraint on `purchase_order_lines(po_id, item_id)` is the final safeguard against duplicate line items in automated procurement.

### Asynchronous Potential
- **`DBMS_SCHEDULER`**: For heavy analytics or broad reorder checks (e.g., grouping across the whole warehouse), migrating logic from real-time triggers to scheduled background jobs as the traffic scales is recommended.

## Implementation Guidelines

1. **Modularize Logic**: Wrap reorder and batching logic in a PL/SQL package (e.g., `PKG_PROCUREMENT`). Triggers should act only as simple call-wrappers.
2. **Dynamic Resolution**: Replace hardcoded location strings (e.g., 'LOC-WHS-01') with metadata lookups or parameter-driven logic to ensure maintainability.

---

*Verified: April 2026*
