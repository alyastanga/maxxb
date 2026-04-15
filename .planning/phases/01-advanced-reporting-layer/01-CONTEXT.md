# Phase 1: Advanced Reporting Layer - Context

**Gathered**: 16-Apr-2026
**Status**: Ready for planning

## Phase Boundary

This phase delivers the analytical SQL views required for the Maxxbrands executive dashboard and warehouse operations tracking.

## Implementation Decisions

### 1. Revenue Analytics (`vw_executive_dashboard`)
- **Metric: Net Revenue** — Pure product subtotal (excluding tax/shipping). Used for ROI and stock valuation.
- **Metric: Gross Revenue** — Total transaction amount (including tax/shipping). Used for cash flow monitoring.
- **Aggregation** — Summed per day for the current date.

### 2. Stock Health (`vw_inventory_master`)
- **Critical Threshold** — Standard `qty_on_hand <= min_threshold` logic.
- **Emergency Flag** — Secondary indicator for `qty_on_hand <= 0` (Out of Stock).

### 3. Sales Velocity (`vw_sales_velocity`)
- **Timeframe** — 30-day trailing average.
- **Derived Metric: Days of Stock Remaining** — `current_qty / avg_daily_sales`.

## Canonical References

- [REQUIREMENTS.md](file:///Users/familyaccount/SQL%20Masters/final/.planning/REQUIREMENTS.md) — Source for Dashboard and Velocity requirements (Section 3).
- [maxxbrands.sql](file:///Users/familyaccount/SQL%20Masters/final/maxxbrands.sql) — Core schema for `inventory` and `sales`.
- [views.sql](file:///Users/familyaccount/SQL%20Masters/final/views.sql) — Target file for new definitions.

---

*Phase: 01-advanced-reporting-layer*
*Context gathered via interactive questioning*
