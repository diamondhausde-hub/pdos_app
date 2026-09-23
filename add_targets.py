
import codecs
import re

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

imports = """import 'package:intl/intl.dart';
import '../../../core/models/target_model.dart';
"""
content = content.replace("import 'package:intl/intl.dart';", imports)

# Find the sliver list to insert the targets section
old_sliver = """              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _QuickActionsSection(),
                    const SizedBox(height: 24),
                    _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                  ]),
                ),
              ),"""

new_sliver = """              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const _TargetsOverviewSection(),
                    const SizedBox(height: 24),
                    const _QuickActionsSection(),
                    const SizedBox(height: 24),
                    _FlaggedVisitsSection(flaggedVisitsAsync: flaggedVisitsAsync),
                  ]),
                ),
              ),"""
content = content.replace(old_sliver, new_sliver)

classes = """
class _TargetsOverviewSection extends ConsumerWidget {
  const _TargetsOverviewSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetsAsync = ref.watch(targetsProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "أهداف الفريق",
              style: AppTextStyles.headlineSm.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        targetsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Text('خطأ في التحميل'),
          data: (targets) {
            if (targets.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: const Center(child: Text("لا توجد أهداف حالياً")),
              );
            }
            final displayTargets = targets.take(2).toList();
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _TargetSquare(target: displayTargets[0]),
                    ),
                    if (displayTargets.length > 1) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: _TargetSquare(target: displayTargets[1]),
                      ),
                    ] else ...[
                      const SizedBox(width: 12),
                      const Spacer(),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // context.push('/supervisor/targets');
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "عرض كل الأهداف",
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _TargetSquare extends StatelessWidget {
  final TargetModel target;
  const _TargetSquare({required this.target});

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
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.track_changes_rounded, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            target.productName ?? 'هدف عام',
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '${target.achievedQty} / ${target.targetQty}',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: target.progress,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            color: target.isAchieved ? AppColors.success : AppColors.primary,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
"""

content = content + classes

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

