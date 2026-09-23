import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/analytics_models.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../shared/widgets/date_range_picker_widget.dart';
import '../../../core/widgets/chart_empty_state.dart';

import '../widgets/performance_layout.dart';

class PerformancePage extends ConsumerWidget {
  const PerformancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const PerformanceLayout(
      currentIndex: 0,
      title: AppStrings.performance,
      child: _PerformanceView(),
    );
  }
}

class _PerformanceView extends ConsumerWidget {
  const _PerformanceView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(analyticsProvider);
    final dailyRevenueAsync = ref.watch(dailyRevenueProvider);
    final monthlyRevenueAsync = ref.watch(monthlyRevenueProvider);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(analyticsProvider);
        ref.invalidate(dailyRevenueProvider);
        ref.invalidate(monthlyRevenueProvider);
        await Future.wait([
          ref.read(analyticsProvider.future),
          ref.read(dailyRevenueProvider.future),
          ref.read(monthlyRevenueProvider.future),
        ]);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.myPerformance, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 8),
            Text(AppStrings.personalKpisTargetProgress,
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 24),
            const DateRangePickerWidget(),
            const SizedBox(height: 20),

            analyticsAsync.when(
              data: (analytics) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: _KpiCard(
                        title: AppStrings.revenue,
                        value: '\$${analytics.totalRevenue.toStringAsFixed(2)}',
                        icon: Icons.attach_money_rounded,
                        color: AppColors.success,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _KpiCard(
                        title: AppStrings.completedVisits,
                        value: '${analytics.visitsCompleted}',
                        icon: Icons.directions_walk_rounded,
                        color: AppColors.secondary,
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _KpiCard(
                        title: AppStrings.targetProgress,
                        value: '${analytics.targetCompletionPercent.toStringAsFixed(1)}%',
                        icon: Icons.track_changes_rounded,
                        color: AppColors.primary,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _KpiCard(
                        title: AppStrings.avgVisits,
                        value: analytics.avgVisitsPerRep.toStringAsFixed(1),
                        icon: Icons.bar_chart_rounded,
                        color: AppColors.info,
                      )),
                    ],
                  ),
                  const SizedBox(height: 28),

                  dailyRevenueAsync.when(
                    data: (dailyData) {
                      if (dailyData.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.dailyRevenueTrend,
                              style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                          const SizedBox(height: 16),
                          GlassCard(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: 200,
                              child: _DailyRevenueChart(data: dailyData),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    },
                    loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    error: (e, s) => const SizedBox.shrink(),
                  ),

                  monthlyRevenueAsync.when(
                    data: (monthlyData) {
                      if (monthlyData.isEmpty) return const SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.monthlyRevenueTrend,
                              style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                          const SizedBox(height: 16),
                          GlassCard(
                            padding: const EdgeInsets.all(20),
                            child: SizedBox(
                              height: 200,
                              child: _MonthlyRevenueChart(data: monthlyData),
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      );
                    },
                    loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                    error: (e, s) => const SizedBox.shrink(),
                  ),

                  Text(AppStrings.topSellingProducts,
                      style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                  const SizedBox(height: 16),
                  if (analytics.topProducts.isEmpty)
                    const ChartEmptyState()
                  else ...[
                    GlassCard(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        height: 200,
                        child: _TopProductsChart(products: analytics.topProducts.take(5).toList()),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...analytics.topProducts.take(5).map((prod) => GlassCard(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text('${prod.rank}',
                                  style: AppTextStyles.labelLg.copyWith(color: AppColors.primary)),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prod.productName,
                                    style: AppTextStyles.bodyLg.copyWith(
                                        fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                                Text('${prod.unitsSold} unit(s) sold',
                                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Text('\$${prod.totalRevenue.toStringAsFixed(2)}',
                              style: AppTextStyles.headlineSm.copyWith(color: AppColors.success)),
                        ],
                      ),
                    )),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text('Error: $err', style: TextStyle(color: AppColors.error)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyRevenueChart extends StatelessWidget {
  final List<DailyRevenueModel> data;
  const _DailyRevenueChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxRev = data.fold<double>(0, (max, d) => d.revenue > max ? d.revenue : max);
    final adjustedMax = maxRev == 0 ? 100.0 : maxRev * 1.2;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: adjustedMax,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[groupIndex].date}\n\$${rod.toY.toStringAsFixed(2)}',
                TextStyle(color: AppColors.onPrimary, fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= data.length) return const SizedBox.shrink();
                final dateStr = data[i].date;
                final parts = dateStr.split('-');
                final day = parts.length >= 3 ? parts[2] : dateStr;
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(day, style: TextStyle(fontSize: 10)),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) {
                return Text('\$${value.toInt()}', style: TextStyle(fontSize: 10));
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: adjustedMax / 4,
        ),
        barGroups: data.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.revenue,
                color: AppColors.primary,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _TopProductsChart extends StatelessWidget {
  final List<ProductPerformanceModel> products;
  const _TopProductsChart({required this.products});

  @override
  Widget build(BuildContext context) {
    final maxRev = products.fold<double>(0, (max, p) => p.totalRevenue > max ? p.totalRevenue : max);
    final adjustedMax = maxRev == 0 ? 100.0 : maxRev * 1.2;

    final colors = [AppColors.primary, AppColors.success, AppColors.secondary, AppColors.info, AppColors.warning];

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: adjustedMax,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final p = products[groupIndex];
              return BarTooltipItem(
                '${p.productName}\n\$${rod.toY.toStringAsFixed(2)}\n${p.unitsSold} unit(s)',
                TextStyle(color: AppColors.onPrimary, fontSize: 12),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= products.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    products[i].productName.length > 8
                        ? '${products[i].productName.substring(0, 8)}...'
                        : products[i].productName,
                    style: TextStyle(fontSize: 9),
                  ),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) => Text('\$${value.toInt()}', style: TextStyle(fontSize: 10)),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: adjustedMax / 4),
        barGroups: products.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value.totalRevenue,
                color: colors[entry.key % colors.length],
                width: 20,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MonthlyRevenueChart extends StatelessWidget {
  final List<MonthlyRevenueModel> data;
  const _MonthlyRevenueChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final maxRev = data.fold<double>(0, (max, d) => d.revenue > max ? d.revenue : max);
    final adjustedMax = maxRev == 0 ? 100.0 : maxRev * 1.2;

    final monthLabels = data.map((d) {
      final parts = d.month.split('-');
      if (parts.length >= 2) {
        final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        final m = int.tryParse(parts[1]) ?? 0;
        return m > 0 && m <= 12 ? months[m] : d.month;
      }
      return d.month;
    }).toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: adjustedMax,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: adjustedMax / 4,
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i < 0 || i >= monthLabels.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(monthLabels[i], style: TextStyle(fontSize: 9)),
                );
              },
              reservedSize: 28,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (value, meta) => Text('\$${value.toInt()}', style: TextStyle(fontSize: 10)),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.revenue)).toList(),
            isCurved: true,
            preventCurveOverShooting: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.08)),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final i = spot.spotIndex;
                return LineTooltipItem(
                  '${monthLabels[i]}\n\$${spot.y.toStringAsFixed(2)}',
                  TextStyle(color: AppColors.onPrimary, fontSize: 12),
                );
              }).toList();
            },
          ),
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
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
