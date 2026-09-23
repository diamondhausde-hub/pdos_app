with open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', encoding='utf-8') as f:
    text = f.read()

import_stmt = "import 'coverage_map_tab.dart';"
new_import_stmt = "import 'coverage_map_tab.dart';\nimport 'supervisor_home_tab.dart';"
if "import 'supervisor_home_tab.dart';" not in text:
    text = text.replace(import_stmt, new_import_stmt)

original_tabs = '''  List<Widget> get _tabs => [
    CoverageMapTab(),
    TeamTab(),
    ReviewTab(),
    PerformanceTab(),
    InventoryTab(),
    AdminCentersTab(),
    AppointmentsTab(),
  ];'''

new_tabs = '''  List<Widget> get _tabs => [
    const SupervisorHomeTab(),
    const TeamTab(),
    const ReviewTab(),
    const PerformanceTab(),
    const InventoryTab(),
    const AdminCentersTab(),
    const AppointmentsTab(),
  ];'''

text = text.replace(original_tabs, new_tabs)

# Fix missing consts if they weren't there
original_tabs2 = '''  List<Widget> get _tabs => [
    CoverageMapTab(),
    TeamTab(),
    ReviewTab(),
    PerformanceTab(),
    InventoryTab(),
    AdminCentersTab(),
    AppointmentsTab(),
  ];'''
new_tabs2 = '''  List<Widget> get _tabs => [
    SupervisorHomeTab(),
    TeamTab(),
    ReviewTab(),
    PerformanceTab(),
    InventoryTab(),
    AdminCentersTab(),
    AppointmentsTab(),
  ];'''
text = text.replace(original_tabs2, new_tabs2)

with open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', encoding='utf-8') as f:
    f.write(text)
