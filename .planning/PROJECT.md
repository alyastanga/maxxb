# Maxxbrands ERP System

## What This Is

An integrated database system designed to automate inventory management, sales monitoring, supplier relationships, and procurement processes for Maxxbrands International INC. It replaces manual, spreadsheet-based tracking with a centralized platform to improve operational efficiency and data accuracy.

## Core Value

Centralized, accurate data that eliminates manual tracking errors and provides real-time visibility into the supply chain.

## Requirements

### Validated

- ✓ **Core ERP Schema** — Functional tables and constraints across all modules (Lookup, Catalog, Logistics, Procurement, Sales).
- ✓ **Automated Stock Sync** — Triggers for inventory increment on receipt and decrement on fulfillment.
- ✓ **Reporting Layer** — Pre-defined views for KPI dashboards, sales velocity, and supplier reliability.
- ✓ **Unified Audit Tracking** — Centralized logging of core data changes and user actions.
- ✓ **Professional ID Generation** — Isolated sequences for consistent ID partitioning across modules.

### Active

- [ ] **Batched Auto-PO Generation** — Enhance reorder logic to group all "Low Stock" items from the same supplier into a single draft PO.
- [ ] **Idempotent Procurement Logic** — Implement safeguards to prevent the system from auto-generating duplicate draft POs for the same supplier/item combination.
- [ ] **Multi-Role Approval Chain** — Formalize authority rules allowing both Warehouse Managers (Jerick Remo) and Store Managers (Hanz Mapua) to approve draft POs.
- [ ] **Resilient Location References** — Refactor triggers to eliminate hardcoded location strings (e.g., 'LOC-WHS-01') in favor of dynamic resolution.

### Out of Scope

- **Frontend Application Development** — Focus remains on the SQL backend; UI/UX handles via external tools.
- **Physical Hardware Integration** — No direct IoT/scanner integration for the current milestone.

## Context

- **Environment**: Oracle Database 23ai.
- **Tools**: Oracle SQL Developer, DBeaver.
- **Current State**: Codebase is fully mapped and baseline schema/automation is implemented. Moving into refinement and advanced automation features.

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition**:
1. Requirements invalidated? → Move to Out of Scope with reason.
2. Requirements validated? → Move to Validated with phase reference.
3. New requirements emerged? → Add to Active.
4. Decisions to log? → Add to Key Decisions.
5. "What This Is" still accurate? → Update if drifted.

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Trigger-Based Automation | Ensures business rules are enforced at the database level regardless of the client app. | ✓ Implemented |
| Sequence-Based Partitioning | Provides human-readable ID blocks (e.g., 10k for POs, 20k for Sales). | ✓ Implemented |
| Batched Auto-PO Strategy | Reduces shipping overhead by grouping multiple low-stock items for the same supplier. | — Pending |
| Dual-Role Approval | Provides operational flexibility by allowing both Warehouse and Store managers to approve. | — Pending |

---

*Last updated: April 16, 2026 after project re-initialization*
