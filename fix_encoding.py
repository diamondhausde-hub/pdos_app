with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# NavBarItemData
content = content.replace("NavBarItemData(icon: Icons.map_rounded, label: '???????')", "NavBarItemData(icon: Icons.map_rounded, label: 'الخريطة')")
content = content.replace("NavBarItemData(icon: Icons.groups_rounded, label: '??????')", "NavBarItemData(icon: Icons.groups_rounded, label: 'الفريق')")
content = content.replace("NavBarItemData(icon: Icons.calendar_month_rounded, label: '????????')", "NavBarItemData(icon: Icons.calendar_month_rounded, label: 'المواعيد')")
content = content.replace("NavBarItemData(icon: Icons.more_horiz_rounded, label: '??????')", "NavBarItemData(icon: Icons.more_horiz_rounded, label: 'المزيد')")

# _MoreSheet header
content = content.replace("Text('??????', style: AppTextStyles.headlineMd)", "Text('المزيد', style: AppTextStyles.headlineMd)")

# Review
content = content.replace("title: '??????',\n              subtitle: '?????? ????????',\n              onTap: onNavigateToReview", "title: 'المراجعة',\n              subtitle: 'مراجعة التقارير',\n              onTap: onNavigateToReview")

# Performance
content = content.replace("title: '??????',\n              subtitle: '???????? ???????',\n              onTap: onNavigateToPerformance", "title: 'الأداء',\n              subtitle: 'إحصائيات المبيعات',\n              onTap: onNavigateToPerformance")

# Inventory
content = content.replace("title: '???????',\n              subtitle: '??? ??????',\n              onTap: onNavigateToInventory", "title: 'المخزون',\n              subtitle: 'جرد المنتجات',\n              onTap: onNavigateToInventory")

# Centers
content = content.replace("title: '???????',\n              subtitle: '????? ???????',\n              onTap: onNavigateToCenters", "title: 'المراكز',\n              subtitle: 'إدارة المراكز',\n              onTap: onNavigateToCenters")

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("Replaced corrupted strings")
