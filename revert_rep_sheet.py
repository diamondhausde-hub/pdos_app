import re

with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

new_more_sheet = """class _MoreSheet extends StatelessWidget {
  const _MoreSheet();

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    final items = [
      _MoreItem(Icons.track_changes_rounded, AppStrings.targets, AppColors.tertiary, () {
        nav.pop();
        context.push('/rep/targets');
      }),
      _MoreItem(Icons.description_rounded, AppStrings.fieldReports, AppColors.warning, () {
        nav.pop();
        context.push('/rep/field-reports');
      }),
      _MoreItem(Icons.help_outline_rounded, AppStrings.helpCenter, AppColors.primary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
      }),
      _MoreItem(Icons.info_outline_rounded, AppStrings.about, AppColors.tertiary, () {
        nav.pop();
        nav.push(MaterialPageRoute(builder: (_) => const AboutScreen()));
      }),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Text(AppStrings.lbl_24, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: item.onTap,
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(color: item.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                            child: Icon(item.icon, color: item.color, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Text(item.label, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant, size: 20),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _MoreItem(this.icon, this.label, this.color, this.onTap);
}"""

content = re.sub(r'class _MoreSheet extends StatelessWidget \{.*?\}(?=\n\nclass _ScreenWrapper|\Z)', new_more_sheet, content, flags=re.DOTALL)

with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Reverted RepShell _MoreSheet back to its original colorful UI")
