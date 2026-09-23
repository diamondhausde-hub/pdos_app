import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../shared/widgets/date_range_picker_widget.dart';
import '../../../core/widgets/chart_empty_state.dart';
import '../../../core/utils/chart_rtl_helpers.dart';
import '../../../core/services/pdf_report_service.dart';

class GeneralManagerAnalyticsTab extends ConsumerStatefulWidget {
  const GeneralManagerAnalyticsTab({super.key});

  @override
  ConsumerState<GeneralManagerAnalyticsTab> createState() =>
      _GeneralManagerAnalyticsTabState();
}

class _GeneralManagerAnalyticsTabState
    extends ConsumerState<GeneralManagerAnalyticsTab> {
  bool _isExporting = false;

  Future<void> _handleExport(WidgetRef ref) async {
    setState(() => _isExporting = true);
    try {
      final analytics = await ref.read(analyticsProvider.future);
      final overview = await ref.read(systemOverviewProvider.future);
      final dateRange = ref.read(dateRangeProvider);
      final brands = ref.read(brandsProvider).asData?.value ?? [];
      final selectedBrandId = ref.read(selectedBrandIdProvider);
      final brandName = brands
              .where((b) => b.id == selectedBrandId)
              .firstOrNull
              ?.name ??
          'All Brands';

      await PdfReportService.generateAndShareAnalyticsReport(
        analytics: analytics,
        overview: overview,
        startDate: dateRange.start,
        endDate: dateRange.end,
        brandName: brandName,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedBrandId = ref.watch(selectedBrandIdProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Analytics & Reports', style: AppTextStyles.h2),
                    const SizedBox(height: 4),
                    Text(
                      selectedBrandId == null
                          ? 'Comparing all brands'
                          : 'Brand specific analytics',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              // Export button — always visible at top
              if (selectedBrandId != null)
                _isExporting
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5),
                        ),
                      )
                    : FilledButton.icon(
                        onPressed: () => _handleExport(ref),
                        icon: Icon(Icons.picture_as_pdf_rounded, size: 18),
                        label: Text('Export PDF'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          textStyle: AppTextStyles.labelSm
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
            ],
          ),
          const SizedBox(height: 16),

          // Date range picker
          const DateRangePickerWidget(),
          const SizedBox(height: 20),

          // Content
          if (selectedBrandId == null)
            _buildAllBrandsComparison(context, ref)
          else
            _buildSingleBrandAnalytics(context, ref),
        ],
      ),
    );
  }

  Widget _buildAllBrandsComparison(BuildContext context, WidgetRef ref) {
    final compareAsync = ref.watch(compareBrandsAnalyticsProvider);

    return compareAsync.when(
      data: (results) {
        if (results.isEmpty) return const ChartEmptyState();

        final successfulBrands =
            results.entries.where((e) => e.value != null).toList();
        final failedBrands =
            results.entries.where((e) => e.value == null).toList();

        if (successfulBrands.isEmpty) {
          return const Center(child: Text('Failed to load any brand data'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (failedBrands.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColors.errorContainer,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Failed to load data for: ${failedBrands.map((e) => e.key).join(", ")}',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ),

            Text('Revenue Comparison', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildComparisonChart(
                context, successfulBrands, (val) => val.totalRevenue),

            const SizedBox(height: 32),
            Text('Visits Comparison', style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _buildComparisonChart(context, successfulBrands,
                (val) => val.visitsCompleted.toDouble()),
          ],
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildComparisonChart(
    BuildContext context,
    List<MapEntry<String, dynamic>> brands,
    double Function(dynamic) getValue,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg(isDark),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
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
                  if (value.toInt() >= 0 && value.toInt() < brands.length) {
                    final name = brands[value.toInt()].key;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        ChartRtlHelpers.formatArabicLabel(context, name),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }
                  return Text('');
                },
                reservedSize: 32,
              ),
            ),
            leftTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: brands.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: getValue(entry.value.value),
                  gradient: AppColors.primaryGradient,
                  width: 24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSingleBrandAnalytics(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final analyticsAsync = ref.watch(analyticsProvider);
    return analyticsAsync.when(
      data: (analytics) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Row
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  label: 'Total Revenue',
                  value: '\$${analytics.totalRevenue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiCard(
                  label: 'Visits',
                  value: '${analytics.visitsCompleted}',
                  icon: Icons.check_circle,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _KpiCard(
                  label: 'Avg Visits/Rep',
                  value: analytics.avgVisitsPerRep.toStringAsFixed(1),
                  icon: Icons.person,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        'Completion',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 60,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 20,
                            sections: [
                              PieChartSectionData(
                                color: AppColors.overseerColor,
                                value: analytics.targetCompletionPercent,
                                title: '',
                                radius: 8,
                              ),
                              PieChartSectionData(
                                color: AppColors.surfaceContainerLow,
                                value: 100 -
                                    analytics.targetCompletionPercent,
                                title: '',
                                radius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${analytics.targetCompletionPercent.toStringAsFixed(1)}%',
                        style: AppTextStyles.h3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Top Products BarChart
          Text('Top Selling Products (Units)', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          if (analytics.topProducts.isEmpty)
            const ChartEmptyState()
          else
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg(isDark),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.softShadow,
              ),
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
                          if (value.toInt() >= 0 &&
                              value.toInt() <
                                  analytics.topProducts.length) {
                            final name = analytics
                                .topProducts[value.toInt()].productName;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                ChartRtlHelpers.formatArabicLabel(
                                    context,
                                    name.length > 8
                                        ? '${name.substring(0, 6)}..'
                                        : name),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return Text('');
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups:
                      analytics.topProducts.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.unitsSold.toDouble(),
                          gradient: AppColors.accentGradient,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 32),

          // Top Reps BarChart
          Text('Top Performing Reps (Revenue)', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          if (analytics.topReps.isEmpty)
            const ChartEmptyState()
          else
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg(isDark),
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.softShadow,
              ),
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
                          if (value.toInt() >= 0 &&
                              value.toInt() <
                                  analytics.topReps.length) {
                            final name =
                                analytics.topReps[value.toInt()].repName;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                ChartRtlHelpers.formatArabicLabel(
                                    context, name.split(' ').first),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }
                          return Text('');
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: false),
                  barGroups:
                      analytics.topReps.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.totalRevenue,
                          gradient: AppColors.primaryGradient,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Error: $err', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => ref.invalidate(analyticsProvider),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h3),
          const SizedBox(height: 4),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
