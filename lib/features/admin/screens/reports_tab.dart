import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/data_providers.dart';
import '../../../shared/widgets/date_range_picker_widget.dart';

class AdminReportsTab extends ConsumerWidget {
  const AdminReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
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
                      Text(AppStrings.reportsExport, style: AppTextStyles.headlineLg.copyWith(color: AppColors.onSurface)),
                      const SizedBox(height: 4),
                      Text(AppStrings.generateAndExportComprehensive,
                          style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.assessment_rounded, color: AppColors.info, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const DateRangePickerWidget(),
              const SizedBox(height: 8),
              _ReportCard(
                icon: Icons.bar_chart_rounded,
                title: AppStrings.salesReport,
                subtitle: AppStrings.revenueOrdersAndProduct,
                color: AppColors.success,
                onGenerate: () => _showExportDialog(context, ref, 'Sales Report', isDark: isDark),
              ),
              _ReportCard(
                icon: Icons.directions_walk_rounded,
                title: AppStrings.visitActivityReport,
                subtitle: AppStrings.visitCompletionRatesBy,
                color: AppColors.primary,
                onGenerate: () => _showExportDialog(context, ref, 'Visit Activity Report', isDark: isDark),
              ),
              _ReportCard(
                icon: Icons.inventory_2_rounded,
                title: AppStrings.inventoryReport,
                subtitle: AppStrings.stockLevelsLowStock,
                color: AppColors.warning,
                onGenerate: () => _showExportDialog(context, ref, 'Inventory Report', isDark: isDark),
              ),
              _ReportCard(
                icon: Icons.people_rounded,
                title: AppStrings.userActivityReport,
                subtitle: AppStrings.loginHistoryActiveUsers,
                color: AppColors.adminColor,
                onGenerate: () => _showExportDialog(context, ref, 'User Activity Report', isDark: isDark),
              ),
              _ReportCard(
                icon: Icons.track_changes_rounded,
                title: AppStrings.targetAchievementReport,
                subtitle: AppStrings.monthlyTargetCompletionBy,
                color: AppColors.secondary,
                onGenerate: () => _showExportDialog(context, ref, 'Target Achievement Report', isDark: isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref, String reportName, String type) async {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.generatingReport)));
    try {
      final api = ApiService.instance;
      final dateRange = ref.read(dateRangeProvider);
      final fmt = DateFormat('yyyy-MM-dd');
      final start = fmt.format(dateRange.start);
      final end = fmt.format(dateRange.end);

      final response = await api.dio.get(
        '/reports/export',
        queryParameters: {'type': type.toLowerCase(), 'start_date': start, 'end_date': end},
        options: Options(responseType: ResponseType.bytes),
      );

      final dir = await getApplicationDocumentsDirectory();
      final ext = type.toLowerCase() == 'excel' ? 'xlsx' : 'csv';
      final fileName = '${reportName.replaceAll(' ', '_')}_${fmt.format(DateTime.now())}.$ext';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(response.data as List<int>);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Saved: $fileName'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Export failed: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showExportDialog(BuildContext context, WidgetRef ref, String reportName, {required bool isDark}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.scaffoldBg(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Export $reportName', style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.table_chart_rounded, color: Colors.green),
              ),
              title: Text(AppStrings.excelXlsx, style: AppTextStyles.bodyLg),
              onTap: () => _exportData(ctx, ref, reportName, 'excel'),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.data_object_rounded, color: Colors.blue),
              ),
              title: Text(AppStrings.csv, style: AppTextStyles.bodyLg),
              onTap: () => _exportData(ctx, ref, reportName, 'csv'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color; final VoidCallback onGenerate;
  const _ReportCard({required this.icon, required this.title, required this.subtitle, required this.color, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: onGenerate,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.download_rounded, color: color, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
