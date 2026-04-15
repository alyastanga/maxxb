# Project Structure - Maxxbrands ERP

Overview of the file organization and key components of the Maxxbrands ERP project.

## Directory Layout

```bash
.
├── .agent/              # Agent configuration and instructions
├── .planning/           # Project planning and codebase intelligence
│   └── codebase/        # [YOU ARE HERE] Structured codebase documentation
├── docs.md              # Project vision, requirements, and functional specifications
├── grants.sql           # Database security and user privilege definitions
├── indexes.sql          # Performance optimization (Indexes and Partitioning)
├── maxxbrands.sql       # Core database schema (Tables and Constraints)
├── seed.sql             # High-fidelity test data for the Oracle environment
├── sequences.sql        # Object ID generation logic
├── triggers.sql         # Automation, data sync, and validation logic
└── views.sql            # Reporting and KPI dashboards
```

## Component Breakdown

### 1. Database Schema (`maxxbrands.sql`)
- Defines the 30+ tables across Catalog, Inventory, Sales, Procurement, and Financial modules.
- Implements data integrity via primary keys, foreign keys, and check constraints.

### 2. Automation Logic (`triggers.sql`)
- Contains the "brain" of the system.
- Handles real-time inventory updates and automated procurement triggers.

### 3. Analytics Layer (`views.sql`)
- Aggregates raw data into human-readable dashboards.
- Examples: `vw_executive_dashboard`, `vw_inventory_master`.

### 4. Technical Infrastructure
- **Sequences (`sequences.sql`)**: Centralizes ID generation to prevent collisions.
- **Grants (`grants.sql`)**: Manages the security boundary for the `MAXXBRANDS` schema.
- **Indexes (`indexes.sql`)**: Optimizes lookup performance for high-traffic tables like `inventory` and `sales_items`.

### 5. Documentation (`docs.md`)
- Acts as the Single Source of Truth for business logic and project objectives.

---

*Last Updated: April 2026*
