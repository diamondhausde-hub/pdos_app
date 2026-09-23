import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/target_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/services/api_service.dart';

class TargetListScreen extends ConsumerStatefulWidget {
  const TargetListScreen({super.key});

  @override
  ConsumerState<TargetListScreen> createState() => _TargetListScreenState();
}

class _TargetListScreenState extends ConsumerState<TargetListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { ref.invalidate(targetsProvider); });
  }

  @override
  Widget build(BuildContext context) {
    final targetsAsync = ref.watch(targetsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.targetList),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ref.invalidate(targetsProvider),
          ),
        ],
      ),
      body: targetsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
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
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.rocket_launch,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(AppStrings.noTargetsYet, style: AppTextStyles.bodyMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Post a new target from the Team tab',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(targetsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final t = targets[index];
                final isExpired = t.periodEnd.isBefore(DateTime.now());

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: isExpired
                              ? LinearGradient(
                                  colors: [
                                    AppColors.outlineVariant.withValues(alpha: 0.5),
                                    AppColors.surfaceContainerLow,
                                  ],
                                )
                              : AppColors.primaryGradient,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.productName ?? 'Unknown Product',
                                    style: AppTextStyles.h4.copyWith(
                                      color: isExpired
                                          ? AppColors.onSurfaceVariant
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        size: 14,
                                        color: isExpired
                                            ? AppColors.outline
                                            : Colors.white70,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        t.repName ?? 'All',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isExpired
                                              ? AppColors.outline
                                              : Colors.white70,
                                        ),
                                      ),
                                      const Spacer(),
                                      Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: isExpired
                                            ? AppColors.outline
                                            : Colors.white70,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'MMM dd',
                                        ).format(t.periodEnd),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: isExpired
                                              ? AppColors.outline
                                              : Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => _showViewers(t.id),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.visibility,
                                        size: 16,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${t.viewCount}',
                                        style: AppTextStyles.labelLarge
                                            .copyWith(
                                              color: AppColors.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                if (t.viewCount > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Viewed',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'Target: ${t.targetQty}',
                                  style: AppTextStyles.h3.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${t.achievedQty} achieved',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: t.progress,
                                minHeight: 8,
                                backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                                valueColor: AlwaysStoppedAnimation(
                                  isExpired
                                      ? AppColors.onSurfaceVariant
                                      : t.isAchieved
                                      ? AppColors.success
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${t.progressPercent.toStringAsFixed(1)}%',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),

                            if (t.notes != null && t.notes!.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.outlineVariant.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.notes,
                                      size: 16,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        t.notes!,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            if (isExpired) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Expired',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => _editTarget(t),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Edit',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: AppColors.outlineVariant.withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => _deleteTarget(t),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: AppColors.error,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Delete',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _editTarget(TargetModel target) {
    final qtyCtrl = TextEditingController(text: target.targetQty.toString());
    final notesCtrl = TextEditingController(text: target.notes ?? '');
    DateTime expiryDate = target.periodEnd;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppStrings.editTarget),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: AppStrings.quantity,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: AppStrings.notes,
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: expiryDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (d != null) setState(() => expiryDate = d);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: AppStrings.expiryDate,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  child: Text(
                    '${expiryDate.year}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () async {
                final qty = int.tryParse(qtyCtrl.text);
                if (qty == null || qty <= 0) return;
                try {
                  await ref
                      .read(targetRepositoryProvider)
                      .updateTarget(target.id, {
                        'target_qty': qty,
                        'notes': notesCtrl.text.trim().isEmpty
                            ? null
                            : notesCtrl.text.trim(),
                        'period_end': expiryDate.toIso8601String(),
                      });
                  if (ctx.mounted) Navigator.pop(ctx);
                  ref.invalidate(targetsProvider);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Edit failed: $e')));
                  }
                }
              },
              child: Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteTarget(TargetModel target) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.deleteTarget),
        content: Text(
          'Are you sure you want to delete the target for ${target.productName ?? ''}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(targetRepositoryProvider)
                    .deleteTarget(target.id);
                if (ctx.mounted) Navigator.pop(ctx);
                ref.invalidate(targetsProvider);
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _showViewers(String targetId) {
    final viewsFuture = _fetchViews(targetId);
    showDialog(
      context: context,
      builder: (ctx) => FutureBuilder<List<Map<String, dynamic>>>(
        future: viewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              content: SizedBox(
                width: 64,
                height: 64,
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          final views = snapshot.data ?? [];
          return AlertDialog(
            title: Text('Views (${views.length})'),
            content: SizedBox(
              width: double.maxFinite,
              child: views.isEmpty
                  ? Text(AppStrings.noViewsYet)
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: views.length,
                      separatorBuilder: (_, _) => const Divider(height: 2),
                      itemBuilder: (context, i) {
                        final v = views[i];
                        final repName = v['rep_name'] as String? ?? 'Rep';
                        final viewedAt = v['viewed_at'] as String? ?? '';
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            radius: 16,
                            child: Text(
                              repName.isNotEmpty
                                  ? repName[0].toUpperCase()
                                  : '?',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          title: Text(repName, style: AppTextStyles.bodyMedium),
                          subtitle: viewedAt.isNotEmpty
                              ? Text(
                                  DateFormat(
                                    'MMM dd, HH:mm',
                                  ).format(DateTime.parse(viewedAt)),
                                  style: AppTextStyles.caption,
                                )
                              : null,
                          trailing: Icon(
                            Icons.visibility,
                            size: 16,
                            color: AppColors.success,
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(AppStrings.close),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchViews(String targetId) async {
    try {
      final response = await ApiService.instance.dio.get(
        '/targets/$targetId/views',
      );
      return (response.data as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return [];
    }
  }
}
