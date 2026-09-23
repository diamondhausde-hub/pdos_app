import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/widgets/glass_card.dart';

class OverseerDashboardTab extends ConsumerWidget {
  const OverseerDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final overviewAsync = ref.watch(systemOverviewProvider);
    // analyticsAsync watched only for invalidation in pull-to-refresh
    final flaggedAsync = ref.watch(flaggedVisitsProvider);

    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(systemOverviewProvider);
        ref.invalidate(analyticsProvider);
        ref.invalidate(flaggedVisitsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Greeting ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user?.fullName ?? 'Overseer',
                              style: AppTextStyles.headlineMd.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.overseerColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('مراقب', style: AppTextStyles.labelSmall.copyWith(color: AppColors.overseerColor)),
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('EEEE, d MMMM yyyy').format(now),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── System Health ─────────────────────────────────────────
            Text('صحة النظام', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            overviewAsync.when(
              data: (overview) => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _HealthCard(
                    title: 'المستخدمين',
                    value: '${overview.totalUsers}',
                    icon: Icons.people_alt_rounded,
                    color: AppColors.primary,
                  ),
                  _HealthCard(
                    title: 'الcenters',
                    value: '${overview.totalCenters}',
                    icon: Icons.store_rounded,
                    color: AppColors.secondary,
                  ),
                  _HealthCard(
                    title: 'المنتجات',
                    value: '${overview.totalProducts}',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.tertiary,
                  ),
                  _HealthCard(
                    title: 'الإيرادات',
                    value: _formatRevenue(overview.totalRevenue),
                    icon: Icons.attach_money_rounded,
                    color: AppColors.success,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('خطأ: $e'),
            ),
            const SizedBox(height: 24),

            // ── Today's Activity ──────────────────────────────────────
            Text("Today's Activity", style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            overviewAsync.when(
              data: (overview) => Column(
                children: [
                  _ActivityRow('Visits Today', '${overview.visitsToday}', Icons.directions_run_rounded, AppColors.primary),
                  const SizedBox(height: 8),
                  flaggedAsync.when(
                    data: (flagged) => _ActivityRow('زيارات مشبوهة', '${flagged.length}', Icons.warning_amber_rounded, flagged.isEmpty ? AppColors.onSurfaceVariant : AppColors.error),
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 8),
                  _ActivityRow('Pending Appointments', '${overview.pendingAppointments}', Icons.calendar_month_rounded, overview.pendingAppointments > 0 ? AppColors.warning : AppColors.onSurfaceVariant),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('خطأ: $e'),
            ),
            const SizedBox(height: 24),

            // ── Regional Coverage ─────────────────────────────────────
            Text('Geographic Coverage', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            overviewAsync.when(
              data: (overview) {
                if (overview.regionCoverage.isEmpty) {
                  return const Text('لا توجد بيانات للتغطية');
                }
                return Column(
                  children: overview.regionCoverage.map((r) => GlassCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(r.region, style: AppTextStyles.labelMedium),
                            Text('${r.coveragePercent.toStringAsFixed(1)}%', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: r.coveragePercent / 100.0,
                            minHeight: 8,
                            backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('خطأ: $e'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) return 'صباح الخير 🌅';
    if (hour < 17) return 'مساء النور ☀️';
    return 'مساء الخير 🌙';
  }

  String _formatRevenue(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M IQD';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K IQD';
    return '${v.toStringAsFixed(0)} IQD';
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _HealthCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
              Text(title, style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _ActivityRow(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.labelMedium)),
          Text(value, style: AppTextStyles.headlineSm.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
