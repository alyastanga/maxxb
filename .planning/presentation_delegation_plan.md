# Presentation Delegation Plan: Maxxbrands ERP System

Tomorrow is the big day. To ensure a smooth and professional demonstration of the **Maxxbrands ERP system**, the task has been delegated based on each member's technical role and project contributions.

## Team Roles & Assignments

| Presenter | Technical Component | Focus Area |
| :--- | :--- | :--- |
| **Peter** | **The Data Foundation** | Schema Design, Sequences, and System Security (Roles). |
| **Hanz** | **Store Operations** | Multi-Role Approval logic and Store manager workflows. |
| **Jerick** | **Warehouse Intelligence** | Automated Stock Sync, Procurement Triggers, and Inventory Resilience. |
| **Kurt** | **Transactional Integrity** | Sales Workflow, Item Cataloging, and Error Handling. |
| **Sean** | **Logistics & Fulfillment** | Supply Chain visibility, Fulfillment Queue, and Driver tracking. |
| **You (Lead)** | **Executive Analytics** | KPI Dashboards, Sales Velocity, and Project Summary/Roadmap. |

---

## Detailed Presentation Flow

### 1. Introduction (You)
- **Objective**: Set the stage.
- **Content**: Project vision, "Spreadsheet to SQL" transition, and technical stack (Oracle 23ai).

### 2. Base Schema & Security (Peter)
- **Objective**: Show how we built the "Source of Truth".
- **Content**: Explain the modular schema design and how DB roles prevent unauthorized data mutation. Show the `PKG_CORE` for global settings.

### 3. Sales & Point of Sale (Kurt)
- **Objective**: Demonstrate the entry point of data.
- **Content**: The `sales` and `sales_items` triggers. Show how a sale automatically updates the `audit_logs`.

### 4. Operations & Approval Chain (Hanz)
- **Objective**: Highlight flexibility.
- **Content**: Demonstrate how a Store Manager (Hanz) can override or approve high-value transactions, showing the multi-role authority logic in `REQUIREMENTS.md`.

### 5. Warehouse Automation (Jerick)
- **Objective**: The "Magic" of the backend.
- **Content**: Show the **Intelligent Procurement Triggers**. Explain how the system detects low stock and generates a draft PO automatically without mutation errors.

### 6. Fulfillment & Logistics (Sean)
- **Objective**: Closing the loop.
- **Content**: Present the `vw_fulfillment_queue`. Explain how drivers use the system to track pending deliveries and update status.

### 7. Executive Dashboards & Analytics (You)
- **Objective**: The "Wow" factor.
- **Content**: Showcase the `vw_executive_dashboard` and `vw_sales_velocity` views. Explain how we use 30-day velocity to predict stock-outs.

### 8. Conclusion & UAT (Team)
- **Objective**: Proof of success.
- **Content**: Present the final UAT results (Phase 4). Open for Q&A.

---

## Open Questions for the Team
- **Peter**: Do we have the latest `grants.sql` ready to show the role isolation?
- **Jerick**: Can we run a live "Low Stock" trigger during the demo?
- **Sean**: Is the seed data for deliveries varied enough for the queue view?

---

*Last updated: April 16, 2026*
