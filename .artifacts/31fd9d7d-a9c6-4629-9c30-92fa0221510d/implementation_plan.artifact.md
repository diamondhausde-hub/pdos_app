# Implementation Plan - Fix Compilation Errors in Visit Detail Screen

The project is currently failing to compile due to missing required named parameters in manual constructor calls for Drift data classes (`LocalVisit`, `LocalVisitItem`, etc.) within `lib/features/rep/screens/visit_detail_screen.dart`. These fields (like `createdAt`, `updatedAt`, `requiresAdminApproval`) were recently added to the database schema but the manual mappings from remote API data weren't updated.

## User Review Required

> [!IMPORTANT]
> This change strictly fixes compilation errors by providing the missing required fields in manual model constructors. I will use values from the API response where available, falling back to `DateTime.now()` or default boolean values where necessary to satisfy the model constraints.

## Proposed Changes

### [Visit Detail Screen]

#### [MODIFY] [visit_detail_screen.dart](file:///C:/Users/prote/Music/PDOS/pdos_app/lib/features/rep/screens/visit_detail_screen.dart)
- Update `visitDetailProvider` to include missing required parameters in:
    - `LocalVisit` constructor: `createdAt`, `updatedAt`.
    - `LocalVisitItem` constructor: `createdAt`.
    - `LocalSpecialRequest` constructor: `createdAt`.
    - `LocalVisitPhoto` constructor: `createdAt`.
    - `LocalExpense` constructor: `createdAt`, `requiresAdminApproval`.

## Verification Plan

### Automated Tests
- I will attempt to trigger a build or use `analyze_file` to verify that the compilation errors are resolved.

### Manual Verification
- The user should try to run the app again after these changes.
