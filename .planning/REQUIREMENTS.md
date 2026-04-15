# Requirements - Maxxbrands ERP Refinement

Scoped requirements for the "Advanced Views & Automation" milestone of the Maxxbrands ERP system.

## 1. Automated Procurement (Batched)

### 1.1 Supplier-Grouped Draft POs
- **Requirement**: When an inventory item falls below `min_threshold`, the system must automatically create a "Pending" Purchase Order.
- **Grouping**: The PO must include all items from the same preferred supplier that are also below or near their reorder thresholds.
- **Constraint**: Each supplier should only have one active "Pending" PO at a time to prevent duplicate ordering.

### 1.2 Idempotent PO Updates
- **Requirement**: If a "Pending" PO already exists for a supplier, new reorder alerts should append new lines or update existing line quantities in that PO rather than creating a new one.
- **Deduplication**: Prevent duplicate line items for the same SKU in a single PO.

## 2. Multi-Role Authority & Security

### 2.1 Universal Approval Authority
- **Requirement**: Both the **Warehouse Manager** (Jerick Remo) and **Store Managers** (Hanz Mapua) must have the authority to update PO status to 'Approved'.
- **Audit**: Every status change must record the `user_id` of the approver in the `purchase_orders` or `audit_logs` table.

### 2.2 Role-Based Access
- **Requirement**: System must enforce that only users with the 'System Administrator' role can delete or "Void" finalized transactions.

## 3. Advanced Reporting & Insights

### 3.1 Executive Dashboard (Real-Time)
- **Requirement**: A unified view (`vw_executive_dashboard`) showing:
    - Revenue Today (Sum of `total_amount` for current date).
    - Critical Stock Alerts (Count of items below threshold).
    - Active POs (Count of Pending/Approved orders).

### 3.2 Sales Velocity Analytics
- **Requirement**: A view (`vw_sales_velocity`) calculating the 30-day average sales per SKU and estimating "Days of Stock Remaining" based on current inventory.

## 4. System Stability & Maintenance

### 4.1 Resilient Metadata Handling
- **Requirement**: Eliminate hardcoded location and status strings in triggers. Use dynamic lookups or metadata constants.
- **Performance**: Use Statement-Level Compound Triggers to minimize transaction lag during bulk stock updates.

### 4.2 Silent Failure Mitigation
- **Requirement**: If an auto-reorder fails (e.g., no supplier price), the system must generate a high-priority entry in `reorder_alerts` marked for "Manual Review".

---

## Success Criteria
- [ ] Test cases in `seed.sql` trigger successful PO batching.
- [ ] No duplicate "Pending" POs created for the same supplier.
- [ ] Dashboard views reflect real-time seed data changes.
- [ ] Triggers execute without ORA-20001 (Mutation) errors during bulk sales.
