import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/target_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/performance_layout.dart';

class TargetsPage extends ConsumerStatefulWidget {
  const TargetsPage({super.key});

  @override
  ConsumerState<TargetsPage> createState() => _TargetsPageState();
}

class _TargetsPageState extends ConsumerState<TargetsPage> {
  final Set<String> _newlyViewed = {};

  @override
  Widget build(BuildContext context) {
    final targetsAsync = ref.watch(targetsProvider);

    return PerformanceLayout(
      currentIndex: 1,
      title: AppStrings.targets,
      child: targetsAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (targets) {
        if (targets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.track_changes_rounded,
                      size: 28, color: AppColors.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Text(AppStrings.noActiveTargetsRight,
                    style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(targetsProvider);
            _newlyViewed.clear();
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: targets.length,
            itemBuilder: (context, index) {
              final t = targets[index];
              final seen = t.userViewed || _newlyViewed.contains(t.id);
              return _buildTargetCard(t, seen);
            },
          ),
        );
      },
    ));
  }

  Future<void> _markViewed(TargetModel target) async {
    if (target.userViewed || _newlyViewed.contains(target.id)) return;
    try {
      await ApiService.instance.dio.post('/targets/${target.id}/view');
      if (mounted) setState(() => _newlyViewed.add(target.id));
    } catch (_) {}
  }

  Widget _buildTargetCard(TargetModel target, bool seen) {
    final progress = target.progress;
    final percentage = target.progressPercent.toStringAsFixed(1);
    final color = target.isAchieved ? AppColors.success : AppColors.primary;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          await _markViewed(target);
          if (context.mounted) _showTargetDetails(target);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(target.productName ?? 'Product',
                          style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
                      if (seen) ...[
                        const SizedBox(width: 8),
                        Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                      ],
                    ],
                  ),
                ),
                Text('$percentage%',
                    style: AppTextStyles.headlineSm.copyWith(color: color, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${target.periodStart.toIso8601String().split('T').first} - ${target.periodEnd.toIso8601String().split('T').first}',
              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
            ),
            if (target.notes != null && target.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(target.notes!,
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 6,
                        backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                        color: color,
                      ),
                      Icon(
                        target.isAchieved ? Icons.emoji_events_rounded : Icons.track_changes_rounded,
                        color: color,
                        size: 24,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.currentProgress,
                          style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text('${target.achievedQty} / ${target.targetQty}',
                          style: AppTextStyles.headlineMd.copyWith(color: AppColors.onSurface)),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                          color: color,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showTargetDetails(TargetModel target) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (target.userViewed || _newlyViewed.contains(target.id))
                    Icon(Icons.check_circle_rounded, size: 20, color: AppColors.success),
                  if (target.userViewed || _newlyViewed.contains(target.id))
                    const SizedBox(width: 8),
                  Expanded(
                    child: Text(target.productName ?? 'Product',
                        style: AppTextStyles.headlineMd),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _detailRow('Target', '${target.targetQty}'),
              _detailRow('Achieved', '${target.achievedQty}'),
              _detailRow('Progress', '${target.progressPercent.toStringAsFixed(1)}%'),
              _detailRow('From', target.periodStart.toIso8601String().split('T').first),
              _detailRow('To', target.periodEnd.toIso8601String().split('T').first),
              if (target.notes != null && target.notes!.isNotEmpty)
                _detailRow('Notes', target.notes!),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(AppStrings.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
          Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}
