import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/user_model.dart';
import '../../../core/models/visit_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/services/api_service.dart';
import '../../rep/screens/visit_detail_screen.dart';

class RepReport {
  final String repName;
  final String repEmail;
  final String? repPhone;
  final String? repRegion;
  final int totalVisits;
  final double totalRevenue;
  final int totalSoldQty;
  final int visitsCompleted;
  final int visitsFlagged;
  final int visitsRejected;
  final int targetQty;
  final int achievedQty;
  final double targetCompletionPercent;
  final List<dynamic> topProducts;
  final List<VisitModel> recentVisits;
  final String periodStart;
  final String periodEnd;

  RepReport.fromJson(Map<String, dynamic> json)
    : repName = json['rep_name'] as String,
      repEmail = json['rep_email'] as String,
      repPhone = json['rep_phone'] as String?,
      repRegion = json['rep_region'] as String?,
      totalVisits = json['total_visits'] as int,
      totalRevenue = (json['total_revenue'] as num).toDouble(),
      totalSoldQty = json['total_sold_qty'] as int,
      visitsCompleted = json['visits_completed'] as int,
      visitsFlagged = json['visits_flagged'] as int,
      visitsRejected = json['visits_rejected'] as int,
      targetQty = json['target_qty'] as int,
      achievedQty = json['achieved_qty'] as int,
      targetCompletionPercent = (json['target_completion_percent'] as num)
          .toDouble(),
      topProducts = json['top_products'] as List<dynamic>,
      recentVisits = (json['recent_visits'] as List<dynamic>)
          .map((e) => VisitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      periodStart = json['period_start'] as String,
      periodEnd = json['period_end'] as String;
}

final repReportProvider = FutureProvider.family<RepReport?, String>((
  ref,
  repId,
) async {
  try {
    final api = ApiService.instance;
    final response = await api.dio.get('/analytics/rep/$repId/report');
    return RepReport.fromJson(response.data as Map<String, dynamic>);
  } catch (e, stack) {
    // ignore: avoid_print
    print('RepReport Error: $e\n$stack');
    rethrow;
  }
});

class RepReportScreen extends ConsumerWidget {
  final UserModel rep;

  const RepReportScreen({super.key, required this.rep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(repReportProvider(rep.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${rep.fullName.split(' ').first}\'s Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            tooltip: AppStrings.downloadPdf,
            onPressed: () => _downloadPdf(context, rep.id),
          ),
        ],
      ),
      body: reportAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (report) {
          if (report == null) {
            return const Center(child: Text(AppStrings.noData));
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(repReportProvider(rep.id)),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rep Info Card
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            report.repName[0].toUpperCase(),
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(report.repName, style: AppTextStyles.h3),
                              Text(
                                report.repEmail,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Region: ${report.repRegion ?? "Not Specified"}',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Period: ${report.periodStart} to ${report.periodEnd}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // KPI Cards
                  Row(
                    children: [
                      _KpiSmall(
                        label: AppStrings.visits,
                        value: '${report.totalVisits}',
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      _KpiSmall(
                        label: AppStrings.sales,
                        value: '${report.totalSoldQty}',
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      _KpiSmall(
                        label: AppStrings.revenue,
                        value: report.totalRevenue.toStringAsFixed(0),
                        color: AppColors.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _KpiSmall(
                        label: AppStrings.completed,
                        value: '${report.visitsCompleted}',
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      _KpiSmall(
                        label: AppStrings.flagged,
                        value: '${report.visitsFlagged}',
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      _KpiSmall(
                        label: AppStrings.rejected,
                        value: '${report.visitsRejected}',
                        color: AppColors.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Target Progress
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.targetProgress, style: AppTextStyles.h4),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: report.targetCompletionPercent / 100,
                          backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                          color: report.targetCompletionPercent >= 100
                              ? AppColors.success
                              : AppColors.primary,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${report.achievedQty} / ${report.targetQty}',
                              style: AppTextStyles.labelMedium,
                            ),
                            Text(
                              '${report.targetCompletionPercent.toStringAsFixed(1)}%',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Top Products
                  if (report.topProducts.isNotEmpty) ...[
                    Text(AppStrings.topSellingProducts, style: AppTextStyles.h4),
                    const SizedBox(height: 12),
                    ...report.topProducts.map((p) {
                      final name = p['product_name'] as String;
                      final units = p['units_sold'] as int;
                      final rev = (p['total_revenue'] as num).toDouble();
                      final rank = p['rank'] as int;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '$rank',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                name,
                                style: AppTextStyles.labelLarge,
                              ),
                            ),
                            Text(
                              '$units units',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${rev.toStringAsFixed(0)} IQD',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],

                  // Recent Visits
                  Text(AppStrings.recentVisits, style: AppTextStyles.h4),
                  const SizedBox(height: 12),
                  ...report.recentVisits.take(5).map((v) {
                    final date =
                        '${v.visitDate.year}-${v.visitDate.month.toString().padLeft(2, '0')}-${v.visitDate.day.toString().padLeft(2, '0')}';
                    final statusStr = switch (v.status) {
                      VisitStatus.completed => 'Completed',
                      VisitStatus.flagged => 'Flagged',
                      VisitStatus.rejected => 'Rejected',
                      _ => v.status.displayName,
                    };
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VisitDetailScreen(visitId: v.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 10,
                              color: v.status == VisitStatus.completed
                                  ? AppColors.success
                                  : v.status == VisitStatus.flagged
                                  ? AppColors.warning
                                  : AppColors.error,
                            ),
                            const SizedBox(width: 8),
                            Text(date, style: AppTextStyles.bodySmall),
                            const Spacer(),
                            Text(
                              statusStr,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context, String repId) async {
    try {
      final api = ApiService.instance;
      final response = await api.dio.get(
        '/analytics/rep/$repId/report/pdf',
        options: Options(responseType: ResponseType.bytes),
      );
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/report_$repId.pdf');
      await file.writeAsBytes(response.data as List<int>);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report downloaded: ${file.path}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _KpiSmall extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _KpiSmall({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.h4.copyWith(color: color)),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
