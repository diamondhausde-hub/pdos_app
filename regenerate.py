import base64
import codecs
import re

with codecs.open('make_home2.py', 'r', 'utf-8') as f:
    text = f.read()

# Just extract anything between quotes if it's the large base64 block
b64_str = ''
for line in text.split('\n'):
    if line.startswith('b64 = "') or line.startswith("b64 = '"):
        b64_str = line[7:-1]
        break
    elif line.startswith('b64 = b"'):
        b64_str = line[8:-1]
        break

if not b64_str:
    b64_match = re.search(r'b64\s*=\s*[\'"]([A-Za-z0-9+/=]+)[\'"]', text)
    if b64_match:
        b64_str = b64_match.group(1)

content = base64.b64decode(b64_str).decode('utf-8', errors='ignore')

# Now apply all fixes properly

# 0. Fix the syntax error (, -> ),
content = content.replace('                (,\n                SliverFillRemaining(', '                ),\n                SliverFillRemaining(')

# 1. Remove _HeaderSection from the CustomScrollView
content = re.sub(r'\s*SliverToBoxAdapter\(\s*child:\s*const _HeaderSection\(\),\s*\),\s*const SliverToBoxAdapter\(\s*child:\s*SizedBox\(height: 24\),\s*\),', '', content)

# 2. Re-write QuickActionsSection
old_quick_actions = re.search(r'class _QuickActionsSection extends StatelessWidget \{[\s\S]*?class _QuickActionBtn extends StatelessWidget \{[\s\S]*?\}\s*\}', content)
if not old_quick_actions:
    print("Could not find quick actions")
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
if old_quick_actions:
    content = content.replace(old_quick_actions.group(0), new_quick_actions)

# 3. Replace KpiCard
old_kpi_card = re.search(r'class _KpiCard extends StatelessWidget \{.*?\n\s*\}\n\s*\}', content, re.DOTALL)
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
            value: 0.75,
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
if old_kpi_card:
    content = content.replace(old_kpi_card.group(0), new_kpi_card)
else:
    print("Could not find KpiCard")


# 4. DeepCoder fixes:
# FlaggedVisit empty Expanded
old_empty = '''                    Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    Text(
                      "لا توجد زيارات مخالفة تحتاج مراجعتك",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                    ),'''
new_empty = '''                    Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "لا توجد زيارات مخالفة تحتاج مراجعتك",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),'''
content = content.replace(old_empty, new_empty)

# FlaggedVisitTile fixes
import re
content = re.sub(
    r'Text\([^,]+,\s*style: AppTextStyles\.labelMd\.copyWith\(fontWeight: FontWeight\.bold\),\s*\),\s*const SizedBox\(height: 4\),\s*Text\([^,]+format\(visit\.visitDate\.toLocal\(\)\),\s*style: AppTextStyles\.labelSm\.copyWith\(color: AppColors\.onSurfaceVariant\),\s*\),',
    '''                    Text(
                      "المندوب: \ - \",
                      style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, hh:mm a').format(visit.visitDate.toLocal()),
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                    ),''',
    content
)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(content)
