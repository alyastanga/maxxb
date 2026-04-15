# Phase 1: Advanced Reporting Layer - Research

Research into high-performance SQL view patterns for the Maxxbrands ERP dashboard.

## 1. Inventory Pulse & Alerts

For real-time stock monitoring (`vw_inventory_master`), we will avoid complex subqueries in favor of simple joins between `inventory` and `items`.

### Optimization: Predicate Pushing
- By keeping the view "Simple" (no grouping/aggregation inside), the Oracle optimizer can "push" filter predicates (e.g., `WHERE location_id = X`) directly into the view's internal queries. This prevents full table scans on global inventory data.

## 2. Sales Velocity Calculation

Calculating 30-day averages efficiently requirement:

### Optimization: Analytic Window Functions
- Use `AVG(...) OVER(PARTITION BY item_id ORDER BY sale_date RANGE BETWEEN INTERVAL '30' DAY PRECEDING AND CURRENT ROW)`.
- **Benefit**: This allows us to calculate the moving average in a single pass over the `sales` table without multiple joins or temporary tables.

## 3. Revenue Metrics

Implementing the "Net vs Gross" requirement:

### Best Practice: Explicit Projections
- Projections will include:
    - `NET_REVENUE`: `total_amount - (tax_amount + shipping_amount)`
    - `GROSS_REVENUE`: `total_amount`
- This dual-column approach allows the UI to serve both operational (Net) and financial (Gross) needs from the same view.

## 4. Oracle 23ai Specifics
- **SQL Transpiler**: While mostly for PL/SQL in SQL, ensuring our view logic stays within standard SQL allows the optimizer to maximize performance without falling back to slower PL/SQL engines.

---

*Verified: April 2026*
