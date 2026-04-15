# Tech Stack - Maxxbrands ERP

Technical overview of the Maxxbrands ERP database system.

## Core Technologies

- **Database Engine**: Oracle 23ai
  - Primary target for the schema and automation logic.
  - Leverages features like `DEFAULT AS IDENTITY` (implied by conversion history) and `RETURNING po_id INTO ...`.
- **Languages**: 
  - **SQL**: Used for data definition (DDL) and manipulation (DML).
  - **PL/SQL**: Used for trigger-based automation and procedural logic in `triggers.sql`.

## Schema & Infrastructure

- **Owner Schema**: `MAXXBRANDS`
- **Object Types**:
  - Tables (Normalized relational model)
  - Sequences (For primary key generation across all tables)
  - Triggers (Inventory synchronization, stock validation, reorder automation)
  - Views (Analytics and reporting)
  - Indexes (Performance optimization)
  - Grants (Access control and system privileges)

## Development Tools

- **IDEs**: 
  - Oracle SQL Developer
  - DBeaver (Used for development and testing)
- **External Dependencies**:
  - None (Zero-dependency SQL-only implementation).

## Configuration

- **Security**: Granular grants provided in `grants.sql` to manage `CREATE SESSION`, `CREATE TABLE`, `CREATE TRIGGER`, etc.
- **Quota**: Unlimited quota on `USERS` tablespace for the `MAXXBRANDS` user.
- **Identity Management**: Uses a mix of manual sequences and potentially identity columns for primary key management.

---

*Last Updated: April 2026*
