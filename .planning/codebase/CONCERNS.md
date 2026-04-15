# Technical Concerns & Risks - Maxxbrands ERP

Identified technical debt, fragile areas, and strategic risks in the Maxxbrands ERP codebase.

## Technical Risks

### 1. Hardcoded Business Logic (Trigger Layer)
- **Warehouse Code Locking**: Several triggers (e.g., `trg_validate_stock_before_sale`, `trg_sync_inv_on_fulfillment`) hardcode the string `'LOC-WHS-01'` for stock validation.
- **Risk**: If the main warehouse location code changes in the `locations` table, critical inventory automation will break silently or start producing incorrect results.

### 2. Silent Failures
- **Auto-PO Generation**: The `trg_auto_po_on_alert` trigger uses an `EXCEPTION WHEN NO_DATA_FOUND THEN NULL` pattern.
- **Risk**: If a warehouse manager or a valid supplier price is missing, the system will fail to create a PO without alerting the user, potentially leading to stockouts.

### 3. ERP Sync Fragmentation
- **SAP Integration**: Integration is limited to `sap_ref_no` tracking. 
- **Risk**: There is no actual data synchronization between the Oracle ERP and the SAP system. Discrepancies between manual input in Oracle and SAP records will require manual reconciliation.

## Technical Debt

### 4. Over-Privileged Schema Owner
- **Security**: The `grants.sql` script provides `ALTER ANY TABLE` and `DROP ANY TABLE` to the `MAXXBRANDS` user.
- **Concern**: While helpful for rapid development, this represents a significant security risk for a production environment where principle of least privilege should be enforced.

### 5. Audit Log Verbosity
- **Detail Management**: Audit logs (`audit_logs`) capture basic status changes but do not store "before" and "after" snapshots of rows.
- **Concern**: Troubleshooting data corruption or accidental deletions may still be difficult without point-in-time state recovery.

## Strategic Risks

### 6. High Dependency on PL/SQL Logic
- **Business Logic Leakage**: A significant portion of the core business logic (procurement rules, validation) is locked in database triggers.
- **Concern**: This makes it difficult to migrate to a different database engine or to implement complex business logic that requires external service calls or complex user interactions.

---

*Last Updated: April 2026*
