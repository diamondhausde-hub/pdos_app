with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# We want to replace the _tabs array initialization
old_tabs = """    _tabs = [
      MyDayTab(onNavigateToTargets: () {
        final ctx = context;
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const _ScreenWrapper(title: AppStrings.targets, child: TargetsPage())));
      }),
      AppointmentsTab(),
      ClientsScreen(),
      CoverageMapTab(),
      ExpensesPage(),
      TargetsPage(),
      ProductsTab(),
      PerformancePage(),
      FieldReportsListScreen(),
    ];"""

new_tabs = """    _tabs = [
      MyDayTab(onNavigateToTargets: () {
        final ctx = context;
        Navigator.push(ctx, MaterialPageRoute(builder: (_) => const _ScreenWrapper(title: AppStrings.targets, child: TargetsPage())));
      }),
      const AppointmentsTab(),
      const ClientsScreen(),
    ];"""

if old_tabs in content:
    content = content.replace(old_tabs, new_tabs)
    with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
        f.write(content)
    print("Replaced _tabs array")
else:
    print("Could not find the exact old_tabs match.")

