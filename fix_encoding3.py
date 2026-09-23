with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# Replace the NavBarItemData
content = re.sub(r"NavBarItemData\(icon:\s*Icons\.map_rounded,\s*label:\s*'.*?'\)", "NavBarItemData(icon: Icons.map_rounded, label: 'الخريطة')", content)
content = re.sub(r"NavBarItemData\(icon:\s*Icons\.groups_rounded,\s*label:\s*'.*?'\)", "NavBarItemData(icon: Icons.groups_rounded, label: 'الفريق')", content)
content = re.sub(r"NavBarItemData\(icon:\s*Icons\.calendar_month_rounded,\s*label:\s*'.*?'\)", "NavBarItemData(icon: Icons.calendar_month_rounded, label: 'المواعيد')", content)
content = re.sub(r"NavBarItemData\(icon:\s*Icons\.more_horiz_rounded,\s*label:\s*'.*?'\)", "NavBarItemData(icon: Icons.more_horiz_rounded, label: 'المزيد')", content)

# Replace the whole _MoreSheet class
more_sheet_pattern = r"class _MoreSheet extends StatelessWidget \{.*?\}(?=\nclass _MoreItem)"
new_more_sheet = """class _MoreSheet extends StatelessWidget {
  final VoidCallback onNavigateToReview;
  final VoidCallback onNavigateToPerformance;
  final VoidCallback onNavigateToInventory;
  final VoidCallback onNavigateToCenters;

  const _MoreSheet({
    required this.onNavigateToReview,
    required this.onNavigateToPerformance,
    required this.onNavigateToInventory,
    required this.onNavigateToCenters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24).copyWith(bottom: MediaQuery.paddingOf(context).bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المزيد', style: AppTextStyles.headlineMd),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _MoreItem(
            icon: Icons.rate_review_rounded,
            title: 'المراجعة',
            subtitle: 'مراجعة التقارير والمهام',
            onTap: onNavigateToReview,
          ),
          const SizedBox(height: 12),
          _MoreItem(
            icon: Icons.insights_rounded,
            title: 'الأداء',
            subtitle: 'إحصائيات المبيعات والأداء',
            onTap: onNavigateToPerformance,
          ),
          const SizedBox(height: 12),
          _MoreItem(
            icon: Icons.inventory_2_rounded,
            title: 'المخزون',
            subtitle: 'جرد وإدارة المنتجات',
            onTap: onNavigateToInventory,
          ),
          const SizedBox(height: 12),
          _MoreItem(
            icon: Icons.store_rounded,
            title: 'المراكز',
            subtitle: 'إدارة مراكز التوزيع',
            onTap: onNavigateToCenters,
          ),
          const SizedBox(height: 12),
          _MoreItem(
            icon: Icons.help_outline_rounded,
            title: 'Help Center',
            subtitle: 'FAQs & Support',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
            },
          ),
        ],
      ),
    );
  }
}
"""

content = re.sub(more_sheet_pattern, new_more_sheet, content, flags=re.DOTALL)

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)

print("Done")
