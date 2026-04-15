# Research: Pitfalls - Maxxbrands ERP

Common pitfalls and edge cases identified for the Maxxbrands ERP database system.

## 1. Mutating Table Errors
- **Scenario**: A trigger on `inventory` tries to query `inventory` to find other low-stock items.
- **Problem**: Oracle prohibits querying the triggering table at the row level.
- **Prevention**: Use **Compound Triggers** to collect IDs in an array at the row level, then perform the query and batch logic at the statement level (`AFTER STATEMENT`).

## 2. Silent Failures in Auto-PO
- **Scenario**: No supplier price exists for a low-stock item.
- **Problem**: The trigger might fail silently (null cost) or crash the parent transaction.
- **Prevention**: Logic must check for price existence and raise a **Reorder Alert** even if a PO cannot be generated, so a human can intervene.

## 3. Recursion & Cascading
- **Scenario**: Triggers updating inventory which in turn fire other inventory triggers.
- **Problem**: Infinite loops or performance death spirals.
- **Prevention**: Use package variables or Oracle's `TRIGGER_DEPTH` function to detect and prevent recursive parent-child updates.

## 4. Hardcoded Metadata
- **Scenario**: Status codes or Location IDs are hardcoded in PL/SQL.
- **Problem**: Brittle code that breaks when the business expands or renames entities.
- **Prevention**: Use a lookup constant table or a dedicated metadata package to centralize "Magic Strings" and IDs.

---

*Verified: April 2026*
