import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/task_model.dart';

class _AnimatedStatusIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool isPulsing;
  final bool isSpinning;

  const _AnimatedStatusIcon({
    required this.icon,
    required this.color,
    this.isPulsing = false,
    this.isSpinning = false,
  });

  @override
  State<_AnimatedStatusIcon> createState() => _AnimatedStatusIconState();
}

class _AnimatedStatusIconState extends State<_AnimatedStatusIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: widget.isPulsing);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPulsing) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.4, end: 1.0).animate(_controller),
        child: Icon(widget.icon, size: 12, color: widget.color),
      );
    } else if (widget.isSpinning) {
      return RotationTransition(
        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
        child: Icon(widget.icon, size: 12, color: widget.color),
      );
    }
    return Icon(widget.icon, size: 12, color: widget.color);
  }
}

class TaskCardWidget extends ConsumerStatefulWidget {
  final SupervisorTask task;
  final VoidCallback onTap;

  const TaskCardWidget({super.key, required this.task, required this.onTap});

  @override
  ConsumerState<TaskCardWidget> createState() => _TaskCardWidgetState();
}

class _TaskCardWidgetState extends ConsumerState<TaskCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.task.status == 'pending' || widget.task.status == 'new') {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant TaskCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.task.status == 'pending' || widget.task.status == 'new') &&
        !(oldWidget.task.status == 'pending' || oldWidget.task.status == 'new')) {
      _pulseController.repeat(reverse: true);
    } else if (widget.task.status != 'pending' && widget.task.status != 'new') {
      _pulseController.stop();
      _pulseController.value = 0.0;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getPriorityColor() {
    switch (widget.task.priority) {
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
    if (widget.task.brandColor != null && widget.task.brandColor!.isNotEmpty) {
      try {
        final hex = widget.task.brandColor!.replaceAll('#', '');
        return Color(int.parse('FF$hex', radix: 16));
      } catch (e) {
        return AppColors.primary;
      }
    }
    return AppColors.primary;
  }

  Widget _buildStatusBadge() {
    Color color;
    IconData icon;
    String label;
    bool isPulsing = false;
    bool isSpinning = false;

    switch (widget.task.status) {
      case 'pending':
        color = Colors.grey;
        icon = Icons.hourglass_empty;
        label = 'بانتظار القبول';
        break;
      case 'accepted_scheduled':
        color = Colors.blue;
        icon = Icons.schedule;
        label = 'مجدولة';
        break;
      case 'upcoming':
        color = Colors.amber;
        icon = Icons.alarm;
        label = 'قريبة';
        isPulsing = true;
        break;
      case 'in_progress':
        color = Colors.green;
        icon = Icons.sync;
        label = 'قيد التنفيذ';
        isSpinning = true;
        break;
      case 'completed':
        color = Colors.grey.shade400;
        icon = Icons.check_circle;
        label = 'مكتملة';
        break;
      case 'overdue':
        color = Colors.red;
        icon = Icons.warning;
        label = 'متأخرة';
        break;
      case 'abandoned':
        color = Colors.deepOrange;
        icon = Icons.directions_run;
        label = 'متروكة';
        break;
      case 'rejected':
        color = Colors.redAccent;
        icon = Icons.cancel;
        label = 'مرفوضة';
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
        label = widget.task.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AnimatedStatusIcon(
            icon: icon,
            color: color,
            isPulsing: isPulsing,
            isSpinning: isSpinning,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.labelSm.copyWith(color: color, fontSize: 9, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        widget.task.dueDate != null &&
        widget.task.dueDate!.isBefore(DateTime.now()) &&
        widget.task.status != 'done' &&
        widget.task.status != 'completed';
        
    final brandColor = _getBrandColor();
    final priorityColor = _getPriorityColor();

    Widget cardContent = GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Side (Leading in RTL) - Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: brandColor,
            ),
          ),
          const SizedBox(width: 12),
          // Middle Column - Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  (widget.task.targetName != null && widget.task.targetName!.isNotEmpty) 
                      ? widget.task.targetName! 
                      : widget.task.taskTypeLabel,
                  style: AppTextStyles.headlineSm.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: brandColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.task.taskTypeLabel,
                          style: AppTextStyles.labelSm.copyWith(
                            color: brandColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (widget.task.dueDate != null || widget.task.scheduledDatetime != null) ...[
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: isOverdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('yyyy-MM-dd').format((widget.task.scheduledDatetime ?? widget.task.dueDate)!),
                          style: AppTextStyles.labelSm.copyWith(
                            color: isOverdue ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                      if (widget.task.priority != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: priorityColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.task.priorityLabel,
                            style: AppTextStyles.labelSm.copyWith(
                              color: priorityColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      if (getTaskRemainingTimeText(widget.task) != null &&
                          widget.task.status != 'completed' &&
                          widget.task.status != 'done' &&
                          widget.task.status != 'rejected') ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isOverdue
                                ? Theme.of(context).colorScheme.error.withValues(alpha: 0.1)
                                : AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isOverdue
                                  ? Theme.of(context).colorScheme.error.withValues(alpha: 0.3)
                                  : AppColors.primary.withValues(alpha: 0.2),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                size: 10,
                                color: isOverdue ? Theme.of(context).colorScheme.error : AppColors.primary,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                getTaskRemainingTimeText(widget.task)!,
                                style: AppTextStyles.labelSm.copyWith(
                                  color: isOverdue ? Theme.of(context).colorScheme.error : AppColors.primary,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Right Side (Trailing in RTL) - Status & Chevron
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildStatusBadge(),
              const SizedBox(height: 8),
              Icon(
                Icons.chevron_left, // Points forward in RTL
                color: Theme.of(context).colorScheme.outlineVariant,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );

    // Add pulse animation
    Widget animatedCard = AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: cardContent,
    );

    // Add entrance animation (slide up + fade in)
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: animatedCard,
    );
  }
}

String? getTaskRemainingTimeText(SupervisorTask task) {
  final targetTime = task.scheduledDatetime ?? task.dueDate;
  if (targetTime == null) return null;
  final now = DateTime.now();
  final diff = targetTime.difference(now);

  if (diff.isNegative) {
    final passed = now.difference(targetTime);
    if (passed.inDays > 0) return 'متأخرة بـ ${passed.inDays} يوم';
    if (passed.inHours > 0) return 'متأخرة بـ ${passed.inHours} س';
    return 'متأخرة بـ ${passed.inMinutes} د';
  } else {
    if (diff.inDays > 0) return 'متبقي ${diff.inDays} يوم';
    if (diff.inHours > 0) return 'متبقي ${diff.inHours} س و ${diff.inMinutes % 60} د';
    if (diff.inMinutes > 0) return 'متبقي ${diff.inMinutes} د';
    return 'حان الموعد الآن!';
  }
}

class TaskAcceptDialog {
  static Future<bool> showTaskAcceptDialog(
    BuildContext context,
    WidgetRef ref,
    SupervisorTask task,
  ) async {
    try {
      final String? reminder = await showDialog<String>(
        context: context,
        builder: (ctx) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('هل تريد تعيين تذكير؟'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('بدون تذكير'),
                  onTap: () => Navigator.pop(ctx, 'no_reminder'),
                ),
                ListTile(
                  title: const Text('قبل ساعة'),
                  onTap: () => Navigator.pop(ctx, '1h'),
                ),
                ListTile(
                  title: const Text('قبل 5 ساعات'),
                  onTap: () => Navigator.pop(ctx, '5h'),
                ),
                ListTile(
                  title: const Text('قبل يوم'),
                  onTap: () => Navigator.pop(ctx, '1d'),
                ),
                ListTile(
                  title: const Text('قبل يومين'),
                  onTap: () => Navigator.pop(ctx, '2d'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, null),
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      );

      if (reminder == null) return false;
      final actualReminder = reminder == 'no_reminder' ? null : reminder;

      if (!context.mounted) return false;
      await ref
          .read(taskRepositoryProvider)
          .updateTaskStatus(task.id, 'accepted_scheduled', reminderOffset: actualReminder);
      ref.invalidate(repTasksProvider);
      ref.invalidate(tasksProvider);
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
      }
      return false;
    }
  }
}

class TaskRejectDialog {
  static Future<bool> showTaskRejectDialog(
    BuildContext context,
    WidgetRef ref,
    SupervisorTask task,
  ) async {
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
              decoration: const InputDecoration(
                labelText: 'سبب الرفض (إجباري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (v) =>
                  setState(() => isSubmitEnabled = v.trim().isNotEmpty),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: isSubmitEnabled
                    ? () => Navigator.pop(ctx, reportController.text.trim())
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('تأكيد الرفض'),
              ),
            ],
          ),
        ),
      ),
    );

    if (report != null && report.isNotEmpty && context.mounted) {
      try {
        await ref
            .read(taskRepositoryProvider)
            .updateTaskStatus(task.id, 'rejected', rejectionReport: report);
        ref.invalidate(repTasksProvider);
        ref.invalidate(tasksProvider);
        return true;
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
        }
        return false;
      }
    }
    return false;
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      orElse: () => const SizedBox(),
    );
  }
}

Future<void> handleStartTask(
  BuildContext context,
  WidgetRef ref,
  SupervisorTask task,
) async {
  try {
    await ref
        .read(taskRepositoryProvider)
        .updateTaskStatus(task.id, 'in_progress');
    ref.invalidate(repTasksProvider);
    ref.invalidate(tasksProvider);

    if (!context.mounted) return;
    Navigator.pop(context);

    if (task.visitSubtype == 'doctor') {
      context.push(
        '/rep/doctor-visit?taskId=${task.id}${task.targetId != null ? '&clientId=${task.targetId}' : ''}',
      );
    } else if (task.visitSubtype == 'pharmacy' && task.targetId != null) {
      context.push(
        '/rep/active_visit/unscheduled?clientId=${task.targetId}&taskId=${task.id}',
      );
    } else {
      context.push(
        '/rep/visit/new?taskId=${task.id}${task.targetId != null ? '&clientId=${task.targetId}' : ''}',
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('خطأ: $e')));
    }
  }
}
