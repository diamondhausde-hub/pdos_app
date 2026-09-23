with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re

# We will replace the _MoreSheet and _MoreItem classes in rep_shell.dart 
# with a design that matches supervisor_shell.dart

new_more_sheet = """class _MoreSheet extends StatelessWidget {
  const _MoreSheet();

  @override
  Widget build(BuildContext context) {
    final nav = Navigator.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.all(24).copyWith(bottom: MediaQuery.paddingOf(context).bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.lbl_24, style: AppTextStyles.headlineMd),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _MoreItem(
              icon: Icons.track_changes_rounded,
              title: AppStrings.targets,
              subtitle: AppStrings.trackYourSalesAndGoals,
              onTap: () {
                nav.pop();
                context.push('/rep/targets');
              },
            ),
            const SizedBox(height: 12),
            _MoreItem(
              icon: Icons.description_rounded,
              title: AppStrings.fieldReports,
              subtitle: AppStrings.viewAndSubmitDailyReports,
              onTap: () {
                nav.pop();
                context.push('/rep/field-reports');
              },
            ),
            const SizedBox(height: 12),
            _MoreItem(
              icon: Icons.help_outline_rounded,
              title: AppStrings.helpCenter,
              subtitle: AppStrings.faqsSupport,
              onTap: () {
                nav.pop();
                nav.push(MaterialPageRoute(builder: (_) => const HelpCenterScreen()));
              },
            ),
            const SizedBox(height: 12),
            _MoreItem(
              icon: Icons.info_outline_rounded,
              title: AppStrings.about,
              subtitle: AppStrings.appVersionAndInfo,
              onTap: () {
                nav.pop();
                nav.push(MaterialPageRoute(builder: (_) => const AboutScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}"""

# Using regex to replace the entire _MoreSheet and _MoreItem classes
content = re.sub(r'class _MoreSheet extends StatelessWidget \{.*\}', new_more_sheet, content, flags=re.DOTALL)

with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Updated RepShell _MoreSheet UI")
