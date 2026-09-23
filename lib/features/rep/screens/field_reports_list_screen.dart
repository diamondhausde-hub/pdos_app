import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/local_db/app_database.dart';

final fieldReportsProvider = FutureProvider<List<LocalFieldReport>>((ref) async {
  final db = ref.read(appDatabaseProvider);
  return db.getAllFieldReports();
});

class FieldReportsListScreen extends ConsumerWidget {
  const FieldReportsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportsAsync = ref.watch(fieldReportsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.fieldReports)),
      body: reportsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (reports) {
          if (reports.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.description_outlined, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  Text(AppStrings.noFieldReportsYet, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(fieldReportsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(report.createdAt);
                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(dateStr,
                              style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                          ),
                          Icon(
                            report.synced ? Icons.cloud_done_rounded : Icons.cloud_upload_rounded,
                            size: 16,
                            color: report.synced ? AppColors.success : AppColors.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(report.content, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
                      if (report.photoPath != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(report.photoPath!),
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(),
                          ),
                        ),
                      ],
                      if (report.uploadedUrl != null) ...[
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            report.uploadedUrl!,
                            width: double.infinity,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/rep/submit-report'),
        child: Icon(Icons.add_rounded),
      ),
    );
  }
}
