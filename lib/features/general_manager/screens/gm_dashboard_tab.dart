import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../shared/widgets/date_range_picker_widget.dart';

class GmDashboardTab extends ConsumerWidget {
  const GmDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final overviewAsync = ref.watch(systemOverviewProvider);
    final analyticsAsync = ref.watch(analyticsProvider);
    final compareBrandsAsync = ref.watch(compareBrandsAnalyticsProvider);
    final selectedBrandId = ref.watch(selectedBrandIdProvider);

    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(systemOverviewProvider);
        ref.invalidate(analyticsProvider);
        ref.invalidate(compareBrandsAnalyticsProvider);
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
                      Text(
                        user?.fullName ?? 'General Manager',
                        style: AppTextStyles.headlineMd.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
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
            if (selectedBrandId != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_alt_rounded, size: 16, color: AppColors.warning),
                    const SizedBox(width: 6),
                    Text(
                      'أنت تعرض بيانات علامة تجارية واحدة فقط',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.warning),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // ── Date Range Picker ─────────────────────────────────────
            const DateRangePickerWidget(),
            const SizedBox(height: 24),

            // ── System Alerts ─────────────────────────────────────────
            overviewAsync.when(
              data: (overview) {
                if (overview.lowStockCount == 0 && overview.pendingAppointments <= 5) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    if (overview.lowStockCount > 0)
                      _AlertBanner(
                        icon: Icons.inventory_2_rounded,
                        message: '${overview.lowStockCount} منتجات مخزونها منخفض',
                        color: AppColors.warning,
                      ),
                    if (overview.pendingAppointments > 5)
                      _AlertBanner(
                        icon: Icons.calendar_month_rounded,
                        message: '${overview.pendingAppointments} مواعيد قادمة تحتاج متابعة',
                        color: AppColors.info,
                      ),
                    const SizedBox(height: 16),
                  ],
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),

            // ── KPI Grid ──────────────────────────────────────────────
            overviewAsync.when(
              data: (overview) => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: [
                  _KpiCard(
                    title: 'Total Revenue',
                    value: _formatRevenue(overview.totalRevenue),
                    icon: Icons.attach_money_rounded,
                    color: AppColors.success,
                  ),
                  _KpiCard(
                    title: 'Visits Today',
                    value: '${overview.visitsToday}',
                    icon: Icons.directions_run_rounded,
                    color: AppColors.primary,
                  ),
                  _KpiCard(
                    title: 'Total Users',
                    value: '${overview.totalUsers}',
                    icon: Icons.people_alt_rounded,
                    color: AppColors.secondary,
                  ),
                  _KpiCard(
                    title: 'Stock Alerts',
                    value: '${overview.lowStockCount}',
                    icon: Icons.warning_rounded,
                    color: overview.lowStockCount > 0 ? AppColors.error : AppColors.onSurfaceVariant,
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('خطأ: $e'),
            ),
            const SizedBox(height: 32),

            // ── Brand Comparison ──────────────────────────────────────
            if (selectedBrandId == null) ...[
              Text('Brand Comparison', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              compareBrandsAsync.when(
                data: (brandsMap) {
                  if (brandsMap.isEmpty) {
                    return const Text('لا توجد بيانات للمقارنة');
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: brandsMap.entries.map((entry) {
                        final brandName = entry.key;
                        final data = entry.value;
                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 12),
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(brandName, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 12),
                                if (data == null)
                                  const Text('خطأ في التحميل', style: TextStyle(color: Colors.red))
                                else ...[
                                  _InfoRow('الإيرادات:', _formatRevenue(data.totalRevenue)),
                                  _InfoRow('الزيارات:', '${data.visitsCompleted}'),
                                  _InfoRow('الهدف:', '${data.targetCompletionPercent.toStringAsFixed(0)}%'),
                                ]
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('خطأ: $e'),
              ),
              const SizedBox(height: 32),
            ],

            // ── Top Performing Reps ───────────────────────────────────
            Text('Top Reps', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            analyticsAsync.when(
              data: (analytics) {
                if (analytics.topReps.isEmpty) {
                  return const Text('لا توجد بيانات');
                }
                return Column(
                  children: analytics.topReps.take(5).map((rep) => GlassCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          rep.rank == 1 ? '🥇' : rep.rank == 2 ? '🥈' : rep.rank == 3 ? '🥉' : '#${rep.rank}',
                          style: TextStyle(fontSize: rep.rank <= 3 ? 22 : 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(rep.repName, style: AppTextStyles.labelLarge),
                          Text('${rep.totalVisits} زيارة', style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
                        ])),
                        Text(_formatRevenue(rep.totalRevenue), style: AppTextStyles.labelLarge.copyWith(color: AppColors.success)),
                      ],
                    ),
                  )).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('خطأ: $e'),
            ),
            const SizedBox(height: 32),

            // ── Region Coverage ───────────────────────────────────────
            Text('Geographic Coverage', style: AppTextStyles.h4.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            overviewAsync.when(
              data: (overview) {
                if (overview.regionCoverage.isEmpty) {
                  return const Text('لا توجد بيانات');
                }
                return Column(
                  children: overview.regionCoverage.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
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
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ((r.coveragePercent.isNaN ? 0.0 : r.coveragePercent) / 100.0).clamp(0.0, 1.0),
                            minHeight: 8,
                            backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${r.visitsCompleted} زيارة / ${r.totalCenters} مركز',
                          style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant),
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

class _AlertBanner extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const _AlertBanner({required this.icon, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: AppTextStyles.labelMedium.copyWith(color: color))),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.headlineMd.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(title, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }
}
