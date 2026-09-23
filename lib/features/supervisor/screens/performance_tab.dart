import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../shared/widgets/date_range_picker_widget.dart';
import '../../../core/widgets/chart_empty_state.dart';
import '../../../core/utils/chart_rtl_helpers.dart';

class PerformanceTab extends ConsumerWidget {
  const PerformanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(analyticsProvider);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.teamPerformance, style: AppTextStyles.headlineMd),
            const SizedBox(height: 8),
            Text('Overview of your team\'s performance', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),

            const DateRangePickerWidget(),
            const SizedBox(height: 16),

            analyticsAsync.when(
              data: (analytics) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _KpiCard(title: AppStrings.totalRevenue, value: '${analytics.totalRevenue.toStringAsFixed(0)} IQD', icon: Icons.attach_money, color: AppColors.success)),
                      const SizedBox(width: 12),
                      Expanded(child: _KpiCard(title: AppStrings.totalVisits, value: '${analytics.visitsCompleted}', icon: Icons.directions_walk, color: AppColors.accent)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _KpiCard(title: AppStrings.avgPerRep, value: analytics.avgVisitsPerRep.toStringAsFixed(1), icon: Icons.person, color: AppColors.primary)),
                      const SizedBox(width: 12),
                      Expanded(child: _KpiCard(title: AppStrings.completion, value: '${analytics.targetCompletionPercent.toStringAsFixed(1)}%', icon: Icons.trending_up, color: AppColors.overseerColor)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Text(AppStrings.repRankingVisits, style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  if (analytics.topReps.isEmpty)
                    const ChartEmptyState()
                  else
                    SizedBox(
                      height: 250,
                      child: GlassCard(
                        padding: const EdgeInsets.all(16),
                        child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barTouchData: BarTouchData(enabled: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= 0 && value.toInt() < analytics.topReps.length) {
                                    final name = analytics.topReps[value.toInt()].repName;
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        ChartRtlHelpers.formatArabicLabel(context, name.split(' ').first),
                                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                                      ),
                                    );
                                  }
                                  return Text('');
                                },
                                reservedSize: 32,
                              ),
                            ),
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          barGroups: analytics.topReps.asMap().entries.map((entry) {
                            return BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.totalVisits.toDouble(),
                                  gradient: AppColors.accentGradient,
                                  width: 24,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: Text('Error loading data: $err')),
              ),
            ),
          ],
        ),
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
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
