# ROADMAP.md

Project plan for the refinement and automation of the Maxxbrands ERP system.

## Milestone 1: Automated Logistics & Intelligence

### Phase 0: Base Schema & Seed [✓]
Establish the fundamental database structure and test data volume.
- **Goal**: Functional Oracle Schema with linked data.
- **Outcome**: `maxxbrands.sql`, `seed.sql`, `sequences.sql`.
- **Status**: Completed.

### Phase 1: Advanced Reporting Layer [/]
Implement the analytical views and KPI dashboards for executive visibility.
- **Goal**: Real-time sales velocity and dashboard reporting.
- **Depends on**: Phase 0.
- **Output**: `views.sql`.

### Phase 2: Intelligent Procurement Automation [ ]
Implement batched, idempotent PO generation and multi-role approval logic.
- **Goal**: Automated replenishment without duplicates.
- **Depends on**: Phase 1.
- **Output**: `triggers.sql` (refined), `PKG_PROCUREMENT`.

### Phase 3: System Resilience & Audit [ ]
Finalize the dynamic metadata resolution and unified logging detail.
- **Goal**: Maintainable, audit-ready backend core.
- **Depends on**: Phase 2.
- **Output**: `grants.sql` (refined), consolidated audit triggers.

## Milestone 2: Verification & Handover

### Phase 4: Full System UAT
Execute a comprehensive audit of all requirements against the seed data.
- **Goal**: 100% requirements validation.
- **Outcome**: Final sign-off.

---

## Evolution
This roadmap is updated at milestone transitions or upon discovery of significant technical constraints.
- **Coarse Granularity**: Standard 4-phase structure for rapid execution.
- **Parallelization**: Independent views (P1) and triggers (P2) can be developed concurrently.
