# System Architecture - Maxxbrands ERP

High-level architecture and data flow patterns for the Maxxbrands ERP system.

## Design Philosophy

The system is built as a **Normalized Relational Database** in Oracle 23ai, emphasizing data integrity, automated synchronization, and modularity.

## Data Flow & Modules

### 1. Procurement & Inventory Lifecycle
1. **Source**: Products and suppliers are defined in the catalog.
2. **Order**: `purchase_orders` are created (manually or via `trg_auto_po_on_alert`).
3. **Fulfillment**: When a PO status reaches 'Delivered' and a record is added to `purchases`, the `trg_sync_inv_on_receipt` trigger automatically increments `inventory.qty_on_hand`.

### 2. Sales & Fulfillment Lifecycle
1. **Order**: Sales are recorded in `sales` and `sales_items`.
2. **Validation**: The `trg_validate_stock_before_sale` trigger prevents overselling by checking physical stock levels.
3. **Completion**: When a `fulfillment` is marked as 'COMPLETED', the `trg_sync_inv_on_fulfillment` trigger decrements the corresponding inventory.

### 3. Automated Reorder System
- **Monitoring**: Every inventory update is checked by `trg_monitor_stock_threshold`.
- **Alerting**: If stock drops below `min_threshold`, an entry is created in `reorder_alerts`.
- **Resolution**: `trg_auto_po_on_alert` detects new alerts and automatically creates a new 'Pending' PO with the cheapest supplier found in `supplier_item_prices`.

## Architecture Layers

| Layer | Component | Responsibility |
|-------|-----------|----------------|
| **Storage** | Oracle Tables | Core data persistence with strict CHECK/FK constraints. |
| **Logic** | PL/SQL Triggers | Event-driven automation and data integrity enforcement. |
| **Security** | Oracle Roles/Grants | Schema-level access control and session management. |
| **Analytics** | SQL Views | Real-time reporting, KPI calculation, and data aggregation. |

## Key Technical Patterns

- **Identity Management**: Unified use of `NUMBER` sequences for all primary keys.
- **Status Workflows**: Use of `CHECK` constraints to enforce valid state transitions (e.g., PO status: Pending -> Approved -> In Transit -> Delivered).
- **Concurrency Control**: Oracle's native ACID compliance ensures that simultaneous sales and deliveries maintain accurate stock counts.

---

*Last Updated: April 2026*
