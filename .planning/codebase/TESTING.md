# Testing & Verification - Maxxbrands ERP

Strategies and patterns for verifying the Maxxbrands ERP database implementation.

## Verification Strategy

The project utilizes a **Higher-Fidelity Seed Data (UAT)** strategy. Instead of unit testing individual SQL functions in isolation, the system is validated against a complete, interconnected universe of realistic business data.

## Test Data Components (`seed.sql`)

The `seed.sql` file provides a baseline for all verification activities:
- **Personnel**: 5 employees with varied roles (Admin, Manager, Cashier, Warehouse, Logistics).
- **Catalog**: 10 categories and 31 high-value furniture items (Songdream, Interior Source, etc.).
- **Logistics**: Mixed locations (Warehouse, Showroom) with calibrated stock levels.
- **Transactions**: 10 diverse sales scenarios and 3 purchase orders in different states.

## Automated Verification Logic

Many business rules are self-verifying via the trigger layer:
1. **Stock Protection**: Attempting to insert a sale for items exceeding `qty_on_hand` will trigger an ORA-20001 error.
2. **Reorder Loop**: Reducing stock below `min_threshold` automatically generates a `reorder_alerts` entry, which in turn triggers a new `purchase_orders` record.

## Manual Verification Patterns

### 1. Functional UAT (User Acceptance Testing)
- **Logistics Flow**: Insert a record into `purchases` for a pending PO and verify that `inventory.qty_on_hand` increments correctly.
- **Sales Flow**: Mark a `fulfillment` as 'COMPLETED' and verify that inventory decrements and an `audit_log` is generated.

### 2. Analytical Accuracy
- Queries against views (e.g., `vw_executive_dashboard`) are compared against the raw table data in `sales` and `purchase_orders` to ensure calculation logic (Daily Velocity, Revenue Today) is correct.

### 3. Audit Integrity
- The `audit_logs` table is sampled to ensure that sensitive actions (Price Updates, Inventory Adjustments) are captured with the correct `user_id` and `action_type`.

---

*Last Updated: April 2026*
