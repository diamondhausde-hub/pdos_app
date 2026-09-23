import codecs
import re

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    text = f.read()

# 1. Remove _HeaderSection from the CustomScrollView
text = re.sub(r'\s*SliverToBoxAdapter\(\s*child:\s*const _HeaderSection\(\),\s*\),\s*const SliverToBoxAdapter\(\s*child:\s*SizedBox\(height: 24\),\s*\),', '', text)

# 2. Rewrite _QuickActionsSection
old_quick_actions = '''class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إجراءات سريعة",
          style: AppTextStyles.headlineSm.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _QuickActionBtn(
              icon: Icons.group_add_rounded,
              label: "إضافة طبيب",
              color: AppColors.secondary,
              onTap: () => context.push('/shared/add-client'),
            ),
            _QuickActionBtn(
              icon: Icons.add_business_rounded,
              label: "إضافة صيدلية",
              color: AppColors.tertiary,
              onTap: () => context.push('/shared/add-center'),
            ),
            _QuickActionBtn(
              icon: Icons.calendar_month_rounded,
              label: "جدول زيارات",
              color: AppColors.primary,
              onTap: () => context.push('/supervisor/schedule-visit'),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}'''

new_quick_actions = '''class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "إجراءات سريعة",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.sync_rounded, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.group_add_rounded,
                  color: AppColors.primary,
                  title: "إضافة طبيب",
                  onTap: () => context.push('/shared/add-client'),
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.add_business_rounded,
                  color: AppColors.secondary,
                  title: "إضافة صيدلية",
                  onTap: () => context.push('/shared/add-center'),
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.calendar_month_rounded,
                  color: AppColors.tertiary,
                  title: "جدول زيارات",
                  onTap: () => context.push('/supervisor/schedule-visit'),
                ),
                _buildActionCard(
                  context: context,
                  width: cardWidth,
                  icon: Icons.insights_rounded,
                  color: AppColors.info,
                  title: "أداء الفريق",
                  onTap: () => context.push('/supervisor/performance'),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required double width,
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTextStyles.labelLg.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}'''

text = text.replace(old_quick_actions, new_quick_actions)

# 3. Rewrite _KpiCard
old_kpi_card = '''class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.9), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineMd.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.labelLg.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}'''

new_kpi_card = '''class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineSm.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.8,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}'''

text = text.replace(old_kpi_card, new_kpi_card)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(text)

