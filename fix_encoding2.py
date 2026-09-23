with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# Replace the NavBarItemData ones (if they failed)
content = re.sub(r"NavBarItemData\(icon: Icons.map_rounded, label: '\?+'\)", "NavBarItemData(icon: Icons.map_rounded, label: 'الخريطة')", content)
content = re.sub(r"NavBarItemData\(icon: Icons.groups_rounded, label: '\?+'\)", "NavBarItemData(icon: Icons.groups_rounded, label: 'الفريق')", content)
content = re.sub(r"NavBarItemData\(icon: Icons.calendar_month_rounded, label: '\?+'\)", "NavBarItemData(icon: Icons.calendar_month_rounded, label: 'المواعيد')", content)
content = re.sub(r"NavBarItemData\(icon: Icons.more_horiz_rounded, label: '\?+'\)", "NavBarItemData(icon: Icons.more_horiz_rounded, label: 'المزيد')", content)

# Replace the whole MoreSheet body starting from Text('??????'
pattern = r"Text\('\?+', style: AppTextStyles\.headlineMd\)(.*?_MoreItem.*?)\n\s+\]"

replacement = """Text('المزيد', style: AppTextStyles.headlineMd)\\1
          ]"""

# Since that's complicated, I'll just replace the specific text strings:
content = re.sub(r"Text\('\?+', style: AppTextStyles\.headlineMd\)", "Text('المزيد', style: AppTextStyles.headlineMd)", content)

content = re.sub(r"title:\s*'\?+',\s*subtitle:\s*'\?+ \?+',\s*onTap:\s*onNavigateToReview", "title: 'المراجعة',\n              subtitle: 'مراجعة التقارير',\n              onTap: onNavigateToReview", content)

content = re.sub(r"title:\s*'\?+',\s*subtitle:\s*'\?+ \?+',\s*onTap:\s*onNavigateToPerformance", "title: 'الأداء',\n              subtitle: 'إحصائيات المبيعات',\n              onTap: onNavigateToPerformance", content)

content = re.sub(r"title:\s*'\?+',\s*subtitle:\s*'\?+ \?+',\s*onTap:\s*onNavigateToInventory", "title: 'المخزون',\n              subtitle: 'جرد المنتجات',\n              onTap: onNavigateToInventory", content)

content = re.sub(r"title:\s*'\?+',\s*subtitle:\s*'\?+ \?+',\s*onTap:\s*onNavigateToCenters", "title: 'المراكز',\n              subtitle: 'إدارة المراكز',\n              onTap: onNavigateToCenters", content)


with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("Replaced corrupted strings")
