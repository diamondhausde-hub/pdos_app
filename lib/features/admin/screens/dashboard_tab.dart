import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/analytics_models.dart';

final dashboardAnalyticsProvider = FutureProvider.autoDispose((ref) async {
  final repo = ref.read(analyticsRepositoryProvider);
  final now = DateTime.now();
  final thisMonthStart = DateTime(now.year, now.month, 1);
  final lastMonthStart = DateTime(now.year, now.month - 1, 1);
  final lastMonthEnd = DateTime(now.year, now.month, 0);
  final thisMonthData = await repo.getAnalytics(thisMonthStart, now);
  final lastMonthData = await repo.getAnalytics(lastMonthStart, lastMonthEnd);
  return {'thisMonth': thisMonthData, 'lastMonth': lastMonthData};
});

class AdminDashboardTab extends ConsumerWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(systemOverviewProvider);
    final analyticsAsync = ref.watch(dashboardAnalyticsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(systemOverviewProvider);
        ref.invalidate(dashboardAnalyticsProvider);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 200),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 40,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Dashboard',
                          style: AppTextStyles.headlineLg.copyWith(
                            color: AppColors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Full system control & monitoring',
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.adminColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppColors.adminColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                overviewAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, s) => Center(child: Text('Error: $e')),
                  data: (overview) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.people_rounded,
                                value: '${overview.totalUsers}',
                                label: AppStrings.totalUsers,
                                color: AppColors.primary,
                                change: 'Active users',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.store_rounded,
                                value: '${overview.totalCenters}',
                                label: AppStrings.centers,
                                color: AppColors.secondary,
                                change: '${overview.visitsToday} visits today',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.monetization_on_rounded,
                                value:
                                    '\$${overview.totalRevenue.toStringAsFixed(0)}',
                                label: AppStrings.revenue,
                                color: AppColors.success,
                                change: 'Total revenue',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.assignment_rounded,
                                value: '${overview.totalProducts}',
                                label: AppStrings.products,
                                color: AppColors.info,
                                change: '${overview.lowStockCount} low stock',
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                analyticsAsync.when(
                  data: (analytics) {
                    final thisMonth = analytics['thisMonth'] as AnalyticsModel;
                    final lastMonth = analytics['lastMonth'] as AnalyticsModel;

                    final avgRevenue = thisMonth.visitsCompleted > 0
                        ? (thisMonth.totalRevenue / thisMonth.visitsCompleted)
                        : 0.0;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _KpiCard(
                                title: AppStrings.visits,
                                value: '${thisMonth.visitsCompleted}',
                                subtitle:
                                    '${thisMonth.visitsCompleted - lastMonth.visitsCompleted} vs last month',
                                icon: Icons.directions_walk_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _KpiCard(
                                title: AppStrings.revenue,
                                value:
                                    '\$${thisMonth.totalRevenue.toStringAsFixed(0)}',
                                subtitle:
                                    '\$${(thisMonth.totalRevenue - lastMonth.totalRevenue).toStringAsFixed(0)} vs last month',
                                icon: Icons.trending_up_rounded,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _KpiCard(
                                title: AppStrings.avgVisit,
                                value: '\$${avgRevenue.toStringAsFixed(2)}',
                                subtitle: AppStrings.revenuePerVisit,
                                icon: Icons.analytics_rounded,
                                color: AppColors.secondary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _KpiCard(
                                title: AppStrings.targets,
                                value:
                                    '${thisMonth.targetCompletionPercent.toStringAsFixed(0)}%',
                                subtitle: AppStrings.completionRate,
                                icon: Icons.track_changes_rounded,
                                color: AppColors.info,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                    height: 120,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, s) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String change;
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  change,
                  style: AppTextStyles.labelSm.copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.headlineLg.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySm.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _KpiCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.headlineSm.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  title,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.labelSm.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
