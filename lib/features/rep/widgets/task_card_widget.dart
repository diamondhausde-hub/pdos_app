import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/task_model.dart';

class TaskCardWidget extends ConsumerWidget {
  final SupervisorTask task;
  final VoidCallback onTap;

  const TaskCardWidget({
    super.key,
    required this.task,
    required this.onTap,
  });

  Color _getPriorityColor() {
    switch (task.priority) {
      case 'عاجل':
      case 'high':
      case 'urgent':
        return AppColors.error;
      case 'مهم':
      case 'medium':
        return AppColors.warning;
      default:
        return AppColors.outline;
    }
  }

  Color _getBrandColor() {
    if (task.brandColor != null && task.brandColor!.isNotEmpty) {
      try {
        final hex = task.brandColor!.replaceAll('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      } catch (e) {
        return AppColors.primary;
      }
    }
    return AppColors.primary;
  }

  Widget _buildStartButton(BuildContext context, WidgetRef ref, SupervisorTask task) {
    bool canStart = true;
    String btnText = 'ابدأ المهمة';
    if (task.scheduledDatetime != null) {
      final now = DateTime.now();
      if (now.isBefore(task.scheduledDatetime!)) {
        canStart = false;
        final diff = task.scheduledDatetime!.difference(now);
        if (diff.inHours > 0) {
          btnText = 'بعد ${diff.inHours} ساعة';
        } else if (diff.inMinutes > 0) {
          btnText = 'بعد ${diff.inMinutes} دقيقة';
        } else {
          btnText = 'الآن';
          canStart = true;
        }
      }
    }

    return ElevatedButton(
      onPressed: canStart ? () => handleStartTask(context, ref, task) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: canStart ? AppColors.success : Colors.grey,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        minimumSize: const Size(0, 32),
      ),
      child: Text(btnText),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = task.dueDate != null && task.dueDate!.isBefore(DateTime.now()) && task.status != 'done' && task.status != 'completed';
    final isToday = task.dueDate != null &&
        task.dueDate!.year == DateTime.now().year &&
        task.dueDate!.month == DateTime.now().month &&
        task.dueDate!.day == DateTime.now().day;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: _getBrandColor(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.task_alt, size: 16, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(task.taskTypeLabel, style: AppTextStyles.labelMd.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (task.priority != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getPriorityColor().withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              task.priorityLabel,
                              style: AppTextStyles.labelSm.copyWith(color: _getPriorityColor(), fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (task.targetName != null)
                      Text(task.targetName!, style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
                    if (task.supervisorName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('المشرف: ${task.supervisorName}', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                      ),
                    if (task.notes != null && task.notes!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('ملاحظة: ${task.notes}', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (task.dueDate != null)
                            Row(
                              children: [
                                Icon(Icons.calendar_today, size: 14, color: isOverdue ? AppColors.error : (isToday ? AppColors.success : AppColors.onSurfaceVariant)),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat('yyyy-MM-dd').format(task.dueDate!),
                                  style: AppTextStyles.labelSm.copyWith(color: isOverdue ? AppColors.error : (isToday ? AppColors.success : AppColors.onSurfaceVariant)),
                                ),
                              ],
                            )
                          else
                            const SizedBox(),

                          const SizedBox(width: 12),

                          if (task.status == 'pending')
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => TaskAcceptDialog.showTaskAcceptDialog(context, ref, task),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.success,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                    minimumSize: const Size(0, 32),
                                  ),
                                  child: const Text('قبول'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => TaskRejectDialog.showTaskRejectDialog(context, ref, task),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                    minimumSize: const Size(0, 32),
                                  ),
                                  child: const Text('رفض'),
                                ),
                              ],
                            )
                          else if (task.status == 'scheduled' || task.status == 'accepted')
                            _buildStartButton(context, ref, task)
                          else if (task.status == 'in_progress')
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, 'done');
                                  ref.invalidate(repTasksProvider);
                                  ref.invalidate(tasksProvider);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                minimumSize: const Size(0, 32),
                              ),
                              child: const Text('إنهاء المهمة'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskAcceptDialog {
  static Future<void> showTaskAcceptDialog(BuildContext context, WidgetRef ref, SupervisorTask task) async {
    try {
      await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, 'accepted');
      if (!context.mounted) return;

      final String? reminder = await showDialog<String>(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('هل تريد تعيين تذكير؟'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(title: const Text('بدون تذكير'), onTap: () => Navigator.pop(ctx, null)),
                ListTile(title: const Text('قبل ساعة'), onTap: () => Navigator.pop(ctx, '1h')),
                ListTile(title: const Text('قبل 5 ساعات'), onTap: () => Navigator.pop(ctx, '5h')),
                ListTile(title: const Text('قبل يوم'), onTap: () => Navigator.pop(ctx, '1d')),
                ListTile(title: const Text('قبل يومين'), onTap: () => Navigator.pop(ctx, '2d')),
              ],
            ),
          ),
        ),
      );

      if (!context.mounted) return;
      await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, 'scheduled', reminderOffset: reminder);
      ref.invalidate(repTasksProvider);
      ref.invalidate(tasksProvider);
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }
}

class TaskRejectDialog {
  static Future<void> showTaskRejectDialog(BuildContext context, WidgetRef ref, SupervisorTask task) async {
    final reportController = TextEditingController();
    bool isSubmitEnabled = false;

    final report = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('رفض المهمة'),
            content: TextField(
              controller: reportController,
              decoration: const InputDecoration(labelText: 'سبب الرفض (إجباري)', border: OutlineInputBorder()),
              maxLines: 3,
              onChanged: (v) => setState(() => isSubmitEnabled = v.trim().isNotEmpty),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
              ElevatedButton(
                onPressed: isSubmitEnabled ? () => Navigator.pop(ctx, reportController.text.trim()) : null,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                child: const Text('تأكيد الرفض'),
              ),
            ],
          ),
        ),
      ),
    );

    if (report != null && report.isNotEmpty && context.mounted) {
      try {
        await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, 'rejected', rejectionReport: report);
        ref.invalidate(repTasksProvider);
        ref.invalidate(tasksProvider);
      } catch (e) {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
    }
  }
}

class TaskStatusBadge extends ConsumerWidget {
  const TaskStatusBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(repTasksProvider);
    return tasksAsync.maybeWhen(
      data: (tasks) {
        final newCount = tasks.where((t) => t.status == 'pending').length;
        if (newCount == 0) return const SizedBox();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.error,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$newCount',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      },
      orElse: () => const SizedBox(),
    );
  }
}

Future<void> handleStartTask(BuildContext context, WidgetRef ref, SupervisorTask task) async {
  try {
    await ref.read(taskRepositoryProvider).updateTaskStatus(task.id, 'in_progress');
    ref.invalidate(repTasksProvider);
    ref.invalidate(tasksProvider);

    if (!context.mounted) return;

    if (task.visitSubtype == 'doctor') {
      context.push('/rep/doctor-visit?taskId=${task.id}${task.targetId != null ? '&clientId=${task.targetId}' : ''}');
    } else if (task.visitSubtype == 'pharmacy' && task.targetId != null) {
      context.push('/rep/active_visit/unscheduled?clientId=${task.targetId}&taskId=${task.id}');
    } else {
      context.push('/rep/visit/new?taskId=${task.id}${task.targetId != null ? '&clientId=${task.targetId}' : ''}');
    }
  } catch (e) {
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
  }
}
