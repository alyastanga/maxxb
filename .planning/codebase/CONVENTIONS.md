# Coding Conventions - Maxxbrands ERP

Standards and coding patterns followed in the Maxxbrands ERP database project.

## Naming Conventions

### Tables & Columns
- **Case**: All identifiers are `snake_case`.
- **Primary Keys**: Always named `<table>_id` (e.g., `item_id`, `po_id`).
- **Reference Keys**: Follow the `fk_<table>_<target>` pattern for constraints.
- **Dates/Times**: Use `_date` for DATE types and `_at` or `_time` (or `log_timestamp`) for TIMESTAMP types.

### Database Objects
- **Sequences**: Named `seq_<table>_id` (e.g., `seq_item_id`).
- **Triggers**: Named `trg_<action>_<event>` (e.g., `trg_sync_inv_on_receipt`).
- **Views**: Prefixed with `vw_` (e.g., `vw_inventory_master`).
- **Indexes**: Prefixed with `idx_` followed by the table and column identifiers (e.g., `idx_itm_code`).

## Data Types & Constraints

- **IDs**: Always `NUMBER`.
- **Strings**: Use `VARCHAR2` with appropriate length limits (50, 100, 150, 255).
- **Amounts**: Use `NUMBER(10,2)` or `NUMBER(12,2)` with `CHECK (amount >= 0)`.
- **Booleans/Enums**: Handled via `VARCHAR2` and `CHECK (column IN ('Value1', 'Value2'))`.

## PL/SQL Patterns

- **Error Handling**: Use `RAISE_APPLICATION_ERROR` with specific codes (e.g., `-20001` to `-20999`) for business logic violations.
- **Automation**: Logic is encapsulated in triggers to ensure consistent state transitions without requiring external middleware logic.
- **Modularity**: Large SQL files are divided into logically grouped sections (Catalog, Logistics, Procurement, etc.).

## Documentation Standards

- Each SQL file begins with a standardized header block.
- Comments are used to explain the *purpose* of complex triggers or views (Objective references).

---

*Last Updated: April 2026*
