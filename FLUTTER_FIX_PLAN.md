# Flutter Run Errors Fix Plan

## Summary of Issues Found (166 issues)

### Critical Errors (Blocking)

1. **lib/core/app_export.dart** - Missing Flutter imports (Color, ColorScheme, Colors)
2. **lib/screens/home_dashboard_screen.dart** - Severely malformed with broken syntax
3. **lib/screens/carbon_credits_ledger/carbon_credits_ledger.dart** - Missing dependencies and widget files
4. **test/widget_test.dart** - References non-existent 'MyApp' class

### High Priority Issues

5. **Missing Widget Files**:
   - `transaction_card_widget.dart` (missing .dart extension)
   - `transaction_detail_bottom_sheet_widget.dart` (missing .dart extension)
   - `custom_app_bar.dart` (missing file)

6. **Missing Dependencies**:
   - flutter_slidable package not in pubspec.yaml

### Medium Priority Issues

7. **Deprecated API Usage** - withOpacity needs to be replaced with withValues

## Fix Plan

### Step 1: Fix app_export.dart
Add missing Flutter material imports to fix Color, ColorScheme, and Colors undefined errors.

### Step 2: Fix/Remove home_dashboard_screen.dart
This file is severely broken. Options:
- Delete the file (since home_dashboard/home_dashboard.dart exists)
- Or fix all the syntax errors

### Step 3: Fix carbon_credits_ledger.dart
- Remove flutter_slidable import
- Remove custom_app_bar import  
- Create missing widget files
- Fix missing .dart extensions in imports

### Step 4: Fix widget_test.dart
Change MyApp to CarbonKrishiApp

### Step 5: Add missing dependencies
Add flutter_slidable to pubspec.yaml (if needed) or remove imports

### Step 6: Replace deprecated APIs
Replace all `withOpacity()` with `withValues(alpha: x)`

## Files to Edit

1. `carbon_krishi_app/lib/core/app_export.dart`
2. `carbon_krishi_app/lib/screens/home_dashboard_screen.dart` (delete or fix)
3. `carbon_krishi_app/lib/screens/carbon_credits_ledger/carbon_credits_ledger.dart`
4. `carbon_krishi_app/test/widget_test.dart`
5. `carbon_krishi_app/pubspec.yaml`
6. Create: `carbon_krishi_app/lib/widgets/custom_app_bar.dart`
7. Fix import paths in various files

## Estimated Time
15-20 minutes for all fixes

