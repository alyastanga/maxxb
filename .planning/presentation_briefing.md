# Presentation Briefing: Member-by-Member Guide

This guide provides a detailed explanation for each delegated task. Use this to prepare your individual segments for tomorrow's presentation.

---

## 1. Peter Dela Cruz: THE DATA FOUNDER
> **Task**: Explain the "Core Engine" and Security.

**Why you?** As the System Admin, you established the architectural integrity of the system.
**What to highlight**:
- **Modular Schema**: Explain how we separated Sales, Procurement, and Logistics to ensure scalability.
- **Safety with Sequences**: Show how we use custom sequences (e.g., `seq_po_id`) to maintain clean, partitioned IDs.
- **Role Isolation**: Mention that even though it's one database, roles (Hanz vs. Jerick) ensure a Cashier can't approve a Purchase Order.
- **Key File**: `maxxbrands.sql`, `sequences.sql`, `grants.sql`.

## 2. Kurt Rañeses: THE SALES SPECIALIST
> **Task**: Demonstrate the Point of Sale (POS) & Transaction Flow.

**Why you?** As the front-line "Cashier," you represent how data enters the system.
**What to highlight**:
- **Smooth Transactions**: Show how a sale entry in `vw_pos_daily_summary` captures everything from customer name to cashier ID.
- **Instant Audit**: Mention that every sale Kurt makes is instantly recorded in the `audit_logs` for transparency.
- **Transactional Integrity**: Explain that we use constraints to ensure no sale can happen if the price is missing or the quantity is zero.
- **Key File**: `vw_pos_daily_summary` (in `views.sql`), `sales` table.

## 3. Hanz Mapua: THE OPERATIONS MANAGER
> **Task**: Show the Multi-Role Approval Chain.

**Why you?** As the Store Manager, you are the bridge between retail needs and warehouse stock.
**What to highlight**:
- **Approval Authority**: Show how the `purchase_orders` table tracks who approved the order (`approved_by`).
- **Flexibility**: Explain that both Store and Warehouse managers can approve orders, reducing bottlenecks.
- **Business Logic**: Demonstrate why manager approval is required before a "Pending" order moves to "In Transit".
- **Key File**: `purchase_orders` table, `REQUIREMENTS.md` (Approval section).

## 4. Jerick Remo: THE AUTOMATION ARCHITECT
> **Task**: Showcase the "Intelligent Procurement" Triggers.

**Why you?** As the Warehouse Manager, you need the system to "think" for you so stock never runs out.
**What to highlight**:
- **Automatic Replenishment**: The "Magic" trigger. Show how selling an item below threshold automatically creates a draft PO in `PKG_PROCUREMENT`.
- **Idempotency**: Explain that the system is smart enough *not* to create duplicate POs if one already exists for that supplier.
- **Resilience**: Mention how we fixed "mutating table" errors using compound logic to keep the database stable under load.
- **Key File**: `PKG_PROCUREMENT.sql`, `triggers.sql`.

## 5. Sean Coquia: THE LOGISTICS DIRECTOR
> **Task**: Present Fulfillment & Delivery Visibility.

**Why you?** As the Logistics Driver, you handle the final "Last Mile" of the ERP.
**What to highlight**:
- **The Dashboard**: Show the `vw_fulfillment_queue`. It’s your daily "To-Do" list.
- **Tracking Lifecycle**: Explain the status flow from `PENDING` to `COMPLETED`.
- **Supplier Reliability**: Briefly show how we track if suppliers are delivering on time using the `vw_supplier_reliability` index.
- **Key File**: `vw_fulfillment_queue`, `vw_supplier_reliability`.

## 6. [YOU]: THE PROJECT LEAD
> **Task**: Executive Analytics & Closing.

**Why you?** You are the orchestrer who tied all these specialized segments into a unified system.
**What to highlight**:
- **Executive Vision**: Show the `vw_executive_dashboard`. This is what the owners see.
- **Predictive Insights**: Explain the **Sales Velocity** view—how we predict when we will run out of stock based on the last 30 days.
- **Asset Value**: Use `vw_inventory_valuation` to show the financial scale of the system.
- **Mission Success**: Confirm that all UAT tests passed and the system is ready for production.
- **Key File**: `vw_executive_dashboard`, `vw_sales_velocity`, `vw_inventory_valuation`.

---

### Pro-Tips for the Demo:
1. **Peter** starts first to show the structure.
2. **Kurt** makes a "sale" to trigger a warehouse update.
3. **Jerick** shows how that sale triggered an alert.
4. **Hanz** approves the alert to create a PO.
5. **Sean** shows the delivery queue updating.
6. **You** show the dashboard reflecting all these actions in real-time.

---

*Last updated: April 16, 2026*
