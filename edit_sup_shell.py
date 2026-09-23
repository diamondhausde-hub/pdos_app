import re

with open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', encoding='utf-8') as f:
    text = f.read()

original_tabs = '''  List<Widget> get _tabs => [
    SupervisorDashboardTab(
      onNavigateToTeam: () => setState(() => _currentIndex = 2),
      onNavigateToReview: () => setState(() => _currentIndex = 3),
      onNavigateToMap: () => setState(() => _currentIndex = 1),
      onNavigateToPerformance: () => setState(() => _currentIndex = 4),
    ),
    CoverageMapTab(),
    TeamTab(),
    ReviewTab(),
    PerformanceTab(),
    InventoryTab(),
    AdminCentersTab(),
    AppointmentsTab(),
  ];'''

new_tabs = '''  List<Widget> get _tabs => [
    CoverageMapTab(),
    TeamTab(),
    ReviewTab(),
    PerformanceTab(),
    InventoryTab(),
    AdminCentersTab(),
    AppointmentsTab(),
  ];'''

text = text.replace(original_tabs, new_tabs)

original_nav = '''          // 0=Dashboard 1=Map 2=Team 3=Review 4=Performance ? 7=Appointments
          currentIndex: _currentIndex > 3 ? 4 : _currentIndex,
          onItemSelected: (i) {
            if (i == 4) {
              _showMoreSheet(context);
            } else {
              setState(() => _currentIndex = i);
            }
          },'''

new_nav = '''          // 0=Map 1=Team 2=Review 3=More
          currentIndex: _currentIndex > 2 ? 3 : _currentIndex,
          onItemSelected: (i) {
            if (i == 3) {
              _showMoreSheet(context);
            } else {
              setState(() => _currentIndex = i);
            }
          },'''

text = text.replace(original_nav, new_nav)

original_items = '''          items: [
            const NavBarItemData(icon: Icons.dashboard_rounded, label: 'Dashboard'),
            NavBarItemData(icon: Icons.map_rounded, label: AppStrings.lbl_25),
            NavBarItemData(icon: Icons.groups_rounded, label: AppStrings.lbl_26),
            NavBarItemData(icon: Icons.rate_review_rounded, badgeCount: flaggedCount, label: AppStrings.review),
            const NavBarItemData(icon: Icons.more_horiz_rounded, label: AppStrings.lbl_24),
          ],'''

new_items = '''          items: [
            NavBarItemData(icon: Icons.map_rounded, label: AppStrings.lbl_25),
            NavBarItemData(icon: Icons.groups_rounded, label: AppStrings.lbl_26),
            NavBarItemData(icon: Icons.rate_review_rounded, badgeCount: flaggedCount, label: AppStrings.review),
            const NavBarItemData(icon: Icons.more_horiz_rounded, label: AppStrings.lbl_24),
          ],'''

text = text.replace(original_items, new_items)

# Need to update _showMoreSheet index mappings because performance is now 3, inventory 4, etc
original_sheet = '''      _buildMoreItem(Icons.analytics_rounded, AppStrings.performance, 4),
      _buildMoreItem(Icons.inventory_2_rounded, AppStrings.lbl_28, 5),
      _buildMoreItem(Icons.business_rounded, AppStrings.lbl_29, 6),
      _buildMoreItem(Icons.calendar_month_rounded, AppStrings.appointments, 7),'''

new_sheet = '''      _buildMoreItem(Icons.analytics_rounded, AppStrings.performance, 3),
      _buildMoreItem(Icons.inventory_2_rounded, AppStrings.lbl_28, 4),
      _buildMoreItem(Icons.business_rounded, AppStrings.lbl_29, 5),
      _buildMoreItem(Icons.calendar_month_rounded, AppStrings.appointments, 6),'''

text = text.replace(original_sheet, new_sheet)
# remove the import
text = text.replace("import 'supervisor_dashboard_tab.dart';", "")

with open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
