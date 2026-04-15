# Phase 3: Global System Resilience - Context

**Gathered**: 16-Apr-2026
**Status**: Ready for planning

## Phase Boundary

This phase refactors the codebase to eliminate hardcoded technical debt and hardening core logic against schema changes.

## Hardcoded Targets Identified

The following files contain hardcoded location references that must be normalized:

### 1. [triggers.sql](file:///Users/familyaccount/SQL%20Masters/final/triggers.sql)
- **Line 35**: `SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'` (Inventory Sync).
- **Line 50**: `SELECT location_id FROM MAXXBRANDS.locations WHERE location_code = 'LOC-WHS-01'` (Stock Validation).

### 2. [seed.sql](file:///Users/familyaccount/SQL%20Masters/final/seed.sql)
- **Throughout**: Subqueries using `location_code = 'LOC-WHS-01'` for bulk insertions. (Normalization of seed logic is also in scope to ensure portability).

## Implementation Decisions

### 1. "Default Warehouse" Schema Update
- **Requirement**: Add `is_default VARCHAR2(1) DEFAULT 'N'` to the `MAXXBRANDS.locations` table.
- **Goal**: Allow triggers to find the main warehouse by flag rather than code.

### 2. Core Service Package (`PKG_CORE`)
- **Requirement**: Create a shared package to provide common system parameters.
- **Function: `get_default_location`** — Returns the ID of the location marked `is_default='Y'`.

## Canonical References

- [REQUIREMENTS.md](file:///Users/familyaccount/SQL%20Masters/final/.planning/REQUIREMENTS.md) — Section 5 (System Resilience).
- [maxxbrands.sql](file:///Users/familyaccount/SQL%20Masters/final/maxxbrands.sql) — Core `locations` table.

---

*Phase: 03-system-resilience-audit*
*Context gathered via codebase scan for hardcoded strings.*
