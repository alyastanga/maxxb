# External Integrations - Maxxbrands ERP

Overview of external systems and entities that interact with the Maxxbrands ERP.

## Business Systems

### SAP Integration
- **Role**: Source of sales records and financial reconciliation.
- **Reference Pattern**: Tracked via `sap_ref_no` in the `sales` table (e.g., `sales.sap_ref_no VARCHAR2(100) UNIQUE`).
- **Data Flow**: Sales entries in the ERP are linked back to manual or semi-automated SAP records for enterprise consistency.

## Supply Chain Entities

### Suppliers
The system manages a catalog of international furniture suppliers:
- **Songdream Manufacturing HQ**: Primary furniture source (`SUP-SD-01`).
- **Nordlux Nordic Group**: Lighting and Nordic design (`SUP-NL-02`).
- **Totguard Kids Furniture Corp**: Specialized children's furniture (`SUP-TG-03`).

### Logistics Locations
- **Warehouse**: Central storage in Antipolo City (`LOC-WHS-01`).
- **My Mchome Palazzo 3F**: Showroom location in Taguig City (`LOC-BGC-01`).

## Data Integrations

### Pricing & Catalogs
- **Supplier Item Prices**: Table `supplier_item_prices` acts as a lookup for procurement automation, linking items to specific suppliers with `unit_cost` and `lead_time_days`.
- **Item Attributes**: Detailed furniture specs (material, fabric color, leg color) are stored in `item_attributes` to support project-based sales.

## Communication Patterns

- **Manual Records**: The system replaces legacy spreadsheet/manual tracking while maintaining compatibility with manual "written records" via extensive audit logs and reference fields.

---

*Last Updated: April 2026*
