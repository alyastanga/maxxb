# Research: Features - Maxxbrands ERP

Detailed investigation into the required feature set for the "Advanced Views & Automation" milestone.

## 1. Batched Auto-PO Generation

The primary objective is to move from "One Alert = One PO" to a "One Supplier = One PO" model.

### Functional Requirements
- **Grouping Logic**: When any item hits its `min_threshold`, the system must find the preferred supplier for that item.
- **Scope Expansion**: Instead of just creating a PO for the triggering item, the system should scan the `inventory` for *all other items* from that same supplier that are currently below or near their thresholds.
- **Consolidation**: A single "Pending" PO is created (header + multiple lines) for all identified items.

## 2. Idempotent Procurement

Prevents the "PO Flooding" scenario where a trigger fires multiple times before a human can respond.

### Functional Requirements
- **Pre-check Logic**: Before creating a new draft PO, the system must check the `purchase_orders` table for any existing POs with status 'Pending' or 'Approved' for the same supplier.
- **Update Instead of Insert**: If a 'Pending' PO already exists, the system should simply append the new line item (or update its quantity) rather than creating a second PO.

## 3. Multi-Role Approval Workflow

Refines the security model to support parallel operations between store and warehouse.

### Authority Matrix
- **Store Managers (Hanz Mapua)**: Can approve POs related to showroom stock or direct customer orders.
- **Warehouse Managers (Jerick Remo)**: Can approve stock replenishment for the central warehouse.
- **System Admin (Peter Dela Cruz)**: Global approval and override authority.

## 4. Resilient Location Handling

Future-proofing the codebase against location re-coding.

### Requirements
- **Lookup Resolution**: Triggers should resolve the `location_id` dynamically (e.g., finding the 'Warehouse' type location) instead of relying on a hardcoded code like `'LOC-WHS-01'`.

---

*Verified: April 2026*
