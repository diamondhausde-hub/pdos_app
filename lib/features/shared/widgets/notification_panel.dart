import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/glass_card.dart';

class NotificationPanel extends ConsumerWidget {
  const NotificationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppStrings.notifications, style: AppTextStyles.headlineMd.copyWith(color: AppColors.onPrimary)),
                    notificationsAsync.when(
                      data: (notifications) {
                        final unreadCount = notifications.where((n) => !n.isRead).length;
                        if (unreadCount == 0) return const SizedBox();
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.onPrimary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text('$unreadCount New', style: AppTextStyles.labelSm.copyWith(color: AppColors.onPrimary)),
                        );
                      },
                      loading: () => const SizedBox(),
                      error: (_, _) => const SizedBox(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(AppStrings.stayUpToDate, style: AppTextStyles.bodySm.copyWith(color: Colors.white70)),
              ],
            ),
          ),

          Expanded(
            child: notificationsAsync.when(
              data: (notifications) {
                if (notifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
                          child: Icon(Icons.notifications_none_rounded, size: 32, color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        Text(AppStrings.noNotificationsYet, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  );
                }
                final grouped = _groupByDate(notifications);
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    for (final entry in grouped.entries) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                        child: Text(entry.key, style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
                      ),
                      for (final n in entry.value)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _NotificationTile(
                            notification: n,
                            onTap: () {
                              if (!n.isRead) ref.read(notificationRepositoryProvider).markAsRead(n.id);
                              _navigateToNotification(context, ref, n);
                            },
                            onDelete: () async {
                              final confirmed = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text(AppStrings.deleteNotification),
                                  content: Text(AppStrings.areYouSureYou_69),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel)),
                                    TextButton(onPressed: () => Navigator.pop(ctx, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: Text(AppStrings.delete)),
                                  ],
                                ),
                              );
                              if (confirmed == true) {
                                try {
                                  await ref.read(notificationRepositoryProvider).deleteNotification(n.id);
                                  if (context.mounted) ref.invalidate(notificationsStreamProvider);
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to delete: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red),
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ),
                    ],
                  ],
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading notifications: $err')),
            ),
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                height: 44,
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.done_all_rounded, size: 16),
                        label: Text(AppStrings.read, style: TextStyle(fontSize: 12)),
                        onPressed: () async {
                          final user = ref.read(currentUserProvider);
                          if (user != null) {
                            await ref.read(notificationRepositoryProvider).markAllAsRead(user.id);
                            if (context.mounted) ref.invalidate(notificationsStreamProvider);
                          }
                        },
                      ),
                    ),
                    Container(width: 1, height: 24, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.delete_sweep_rounded, size: 16),
                        label: Text(AppStrings.delete, style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(foregroundColor: AppColors.error),
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(AppStrings.deleteAllNotifications),
                              content: Text(AppStrings.areYouSureYou_70),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel)),
                                TextButton(onPressed: () => Navigator.pop(ctx, true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: Text(AppStrings.deleteAll)),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            try {
                              await ref.read(notificationRepositoryProvider).deleteAllNotifications();
                              if (context.mounted) ref.invalidate(notificationsStreamProvider);
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to delete all: ${e.toString().replaceAll('Exception: ', '')}'), backgroundColor: Colors.red),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ),
                    Container(width: 1, height: 24, color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    Expanded(
                      child: TextButton.icon(
                        icon: Icon(Icons.open_in_new_rounded, size: 16),
                        label: Text(AppStrings.all, style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/notifications');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, List<NotificationModel>> _groupByDate(List<NotificationModel> notifications) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final weekAgo = today.subtract(const Duration(days: 7));

  final grouped = <String, List<NotificationModel>>{
    'Today': [],
    'Yesterday': [],
    'This Week': [],
    'Earlier': [],
  };

  for (final n in notifications) {
    final d = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
    if (d == today) {
      grouped['Today']!.add(n);
    } else if (d == yesterday) {
      grouped['Yesterday']!.add(n);
    } else if (d.isAfter(weekAgo)) {
      grouped['This Week']!.add(n);
    } else {
      grouped['Earlier']!.add(n);
    }
  }

  grouped.removeWhere((_, v) => v.isEmpty);
  return grouped;
}

void _navigateToNotification(BuildContext context, WidgetRef ref, NotificationModel n) {
  final user = ref.read(currentUserProvider);
  final role = user?.role;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(color: _colorForType(n.type).withValues(alpha: 0.12), borderRadius: BorderRadius.circular(14)),
                child: Icon(_iconForType(n.type), size: 24, color: _colorForType(n.type)),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(n.title, style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _colorForType(n.type).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(n.message ?? 'No additional details', style: AppTextStyles.bodyMd.copyWith(height: 1.5)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 14, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(timeago.format(n.createdAt), style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: Icon(Icons.open_in_new_rounded, size: 18),
              label: Text(AppStrings.viewDetails),
              onPressed: () {
                Navigator.pop(ctx);
                _goToRelated(context, n, role);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

void _goToRelated(BuildContext context, NotificationModel n, UserRole? role) {
  switch (n.type) {
    case 'visit_flagged':
    case 'visit_reviewed':
      if (n.relatedId != null) {
        context.push('/rep/visit/${n.relatedId}');
      } else {
        context.go('/rep/my-day');
      }
      break;
    case 'appointment_reminder':
      if (n.relatedId != null) {
        context.push('/center/${n.relatedId}');
      } else {
        context.go('/rep/my-day');
      }
      break;
    case 'low_stock':
    case 'product_added':
    case 'product_removed':
      if (n.relatedId != null) {
        context.push('/center/${n.relatedId}');
      } else {
        context.go('/rep/products');
      }
      break;
    case 'expense_approved':
    case 'expense_rejected':
    case 'expense_pending':
      context.go('/rep/my-day');
      break;
    case 'target_reached':
      context.go('/rep/my-day');
      break;
    case 'deactivation_requested':
      if (n.relatedId != null) {
        context.push('/admin/user/${n.relatedId}');
      } else {
        context.go('/admin/overview');
      }
      break;
    default:
      if (n.relatedId != null) {
        context.push('/center/${n.relatedId}');
      } else {
        context.go('/rep/my-day');
      }
      break;
  }
}

IconData _iconForType(String type) {
  switch (type) {
    case 'low_stock': return Icons.warning_amber_rounded;
    case 'target_reached': return Icons.assignment_turned_in_rounded;
    case 'expiry_alert': return Icons.access_time_filled_rounded;
    case 'appointment_reminder': return Icons.event_rounded;
    case 'product_added': case 'product_removed': return Icons.inventory_2_rounded;
    case 'visit_flagged': return Icons.flag_rounded;
    case 'visit_reviewed': return Icons.rate_review_rounded;
    case 'expense_approved': return Icons.check_circle_rounded;
    case 'expense_rejected': return Icons.cancel_rounded;
    case 'expense_pending': return Icons.hourglass_empty_rounded;
    case 'deactivation_requested': return Icons.person_off_rounded;
    default: return Icons.notifications_rounded;
  }
}

Color _colorForType(String type) {
  switch (type) {
    case 'low_stock': return AppColors.warning;
    case 'target_reached': return AppColors.success;
    case 'expiry_alert': return AppColors.error;
    case 'appointment_reminder': return AppColors.primary;
    case 'product_added': case 'product_removed': return AppColors.secondary;
    case 'visit_flagged': return AppColors.error;
    case 'visit_reviewed': return AppColors.info;
    case 'expense_approved': return AppColors.success;
    case 'expense_rejected': return AppColors.error;
    case 'expense_pending': return AppColors.warning;
    case 'deactivation_requested': return AppColors.error;
    default: return AppColors.onSurfaceVariant;
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({required this.notification, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(notification.type);
    final icon = _iconForType(notification.type);

    return GlassCard(
      padding: const EdgeInsets.all(12),
      variant: notification.isRead ? GlassVariant.normal : GlassVariant.primary,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (!notification.isRead)
                  Positioned(top: 0, right: 0,
                    child: Container(width: 10, height: 10,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle, border: Border.all(color: AppColors.onPrimary, width: 2)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(notification.title,
                          style: AppTextStyles.bodyMd.copyWith(
                            fontWeight: !notification.isRead ? FontWeight.w600 : FontWeight.w400,
                            color: AppColors.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis, maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(timeago.format(notification.createdAt),
                        style: AppTextStyles.labelSm.copyWith(color: !notification.isRead ? color : AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                  if (notification.message != null) ...[
                    const SizedBox(height: 4),
                    Text(notification.message!, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close_rounded, size: 18, color: AppColors.onSurfaceVariant),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              splashRadius: 16,
            ),
          ],
        ),
      ),
    );
  }
}
