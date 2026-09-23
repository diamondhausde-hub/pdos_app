import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/notification_model.dart';
import '../../../core/models/user_model.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _filter = 'all'; // 'all', 'unread', 'read'
  final List<String> _optimisticallyDeletedIds = [];

  List<NotificationModel> _filteredNotifications(List<NotificationModel> all) {
    var filtered = all.where((n) => !_optimisticallyDeletedIds.contains(n.id)).toList();
    switch (_filter) {
      case 'unread':
        return filtered.where((n) => !n.isRead).toList();
      case 'read':
        return filtered.where((n) => n.isRead).toList();
      default:
        return filtered;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      body: notificationsAsync.when(
        data: (notifications) {
          final activeNotifications = notifications.where((n) => !_optimisticallyDeletedIds.contains(n.id)).toList();
          final unreadCount = activeNotifications.where((n) => !n.isRead).length;
          final readCount = activeNotifications.where((n) => n.isRead).length;
          final filtered = _filteredNotifications(notifications);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                expandedHeight: 140,
                pinned: true,
                floating: true,
                backgroundColor: isDark ? const Color(0xFF1A1D2E) : AppColors.primary,
                foregroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  'Notifications',
                  style: AppTextStyles.headlineSm.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  if (activeNotifications.isNotEmpty)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      onSelected: (value) => _handleMenuAction(value, ref),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'mark_read',
                          child: Row(
                            children: [
                              Icon(Icons.done_all_rounded, size: 20, color: AppColors.success),
                              const SizedBox(width: 12),
                              Text(AppStrings.markAllRead, style: AppTextStyles.bodyMd),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete_read',
                          child: Row(
                            children: [
                              Icon(Icons.cleaning_services_rounded, size: 20, color: AppColors.warning),
                              const SizedBox(width: 12),
                              Text(AppStrings.clearRead, style: AppTextStyles.bodyMd),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete_all',
                          child: Row(
                            children: [
                              Icon(Icons.delete_sweep_rounded, size: 20, color: AppColors.error),
                              const SizedBox(width: 12),
                              Text(AppStrings.deleteAll, style: AppTextStyles.bodyMd.copyWith(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF1A1D2E), const Color(0xFF252842)]
                            : [AppColors.primary, AppColors.primary.withValues(alpha: 0.85)],
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(64),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.surface,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        _buildFilterChip('all', 'All', activeNotifications.length, isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('unread', 'New', unreadCount, isDark),
                        const SizedBox(width: 8),
                        _buildFilterChip('read', 'Read', readCount, isDark),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            body: filtered.isEmpty
                ? _buildEmptyState(isDark)
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(notificationsStreamProvider);
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final n = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _SwipeableNotificationCard(
                            key: ValueKey(n.id),
                            notification: n,
                            onTap: () {
                              if (!n.isRead) {
                                ref.read(notificationRepositoryProvider).markAsRead(n.id);
                                ref.invalidate(notificationsStreamProvider);
                              }
                              _showNotificationDetail(context, ref, n);
                            },
                            onDismissed: () => _deleteNotification(n),
                            onMarkRead: () {
                              ref.read(notificationRepositoryProvider).markAsRead(n.id);
                              ref.invalidate(notificationsStreamProvider);
                              HapticFeedback.lightImpact();
                            },
                          ),
                        );
                      },
                    ),
                  ),
          );
        },
        loading: () => Scaffold(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
          appBar: AppBar(title: const Text(AppStrings.notifications)),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                Text(AppStrings.loadingNotifications, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
        ),
        error: (err, stack) => Scaffold(
          appBar: AppBar(title: const Text(AppStrings.notifications)),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                const SizedBox(height: 16),
                Text(AppStrings.failedToLoadNotifications, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurface)),
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text(AppStrings.retry),
                  onPressed: () => ref.invalidate(notificationsStreamProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterKey, String label, int count, bool isDark) {
    final isSelected = _filter == filterKey;
    final primaryColor = isDark ? AppColors.primary : AppColors.primary;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _filter = filterKey);
          HapticFeedback.selectionClick();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? primaryColor.withValues(alpha: 0.3) : AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected ? primaryColor : AppColors.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final messages = {
      'all': ('No notifications yet', 'When you receive notifications, they\'ll appear here', Icons.notifications_none_rounded),
      'unread': ('All caught up!', 'You have no unread notifications', Icons.done_all_rounded),
      'read': ('No read notifications', 'Notifications you\'ve read will appear here', Icons.mark_email_read_outlined),
    };
    final (title, subtitle, icon) = messages[_filter]!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.primary.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text(title, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleMenuAction(String action, WidgetRef ref) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    switch (action) {
      case 'mark_read':
        await ref.read(notificationRepositoryProvider).markAllAsRead(user.id);
        if (mounted) {
          ref.invalidate(notificationsStreamProvider);
          HapticFeedback.mediumImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.done_all_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text(AppStrings.allNotificationsMarkedAs),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
        break;
      case 'delete_read':
        final confirmed = await _showConfirmDialog(
          'Clear Read Notifications',
          'Delete all read notifications? This action cannot be undone.',
        );
        if (confirmed == true) {
          try {
            final notifications = ref.read(notificationsStreamProvider).value ?? [];
            final readNotifications = notifications.where((n) => n.isRead).toList();
            for (final n in readNotifications) {
              await ref.read(notificationRepositoryProvider).deleteNotification(n.id);
            }
            if (mounted) {
              ref.invalidate(notificationsStreamProvider);
              HapticFeedback.mediumImpact();
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(AppStrings.failedToConnectTo),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          }
        }
        break;
      case 'delete_all':
        final confirmed = await _showConfirmDialog(
          'Delete All Notifications',
          'Are you sure you want to delete ALL notifications? This action cannot be undone.',
        );
        if (confirmed == true) {
          try {
            await ref.read(notificationRepositoryProvider).deleteAllNotifications();
            if (mounted) {
              ref.invalidate(notificationsStreamProvider);
              HapticFeedback.heavyImpact();
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(AppStrings.failedToConnectTo),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          }
        }
        break;
    }
  }

  Future<bool?> _showConfirmDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: AppTextStyles.headlineSm),
        content: Text(content, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppStrings.cancel, style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  void _deleteNotification(NotificationModel n) async {
    HapticFeedback.mediumImpact();
    // Optimistically remove from UI immediately
    setState(() {
      _optimisticallyDeletedIds.add(n.id);
    });
    
    try {
      await ref.read(notificationRepositoryProvider).deleteNotification(n.id);
      if (mounted) {
        ref.invalidate(notificationsStreamProvider);
      }
    } catch (e) {
      if (mounted) {
        // Revert on failure
        setState(() {
          _optimisticallyDeletedIds.remove(n.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(child: Text(AppStrings.connectionFailedCouldNot)),
              ],
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  void _showNotificationDetail(BuildContext context, WidgetRef ref, NotificationModel n) {
    final user = ref.read(currentUserProvider);
    final role = user?.role;
    final color = _colorForType(n.type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 12, 24, MediaQuery.of(ctx).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(_iconForType(n.type), size: 26, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: AppTextStyles.headlineSm.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 13, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(timeago.format(n.createdAt), style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _labelForType(n.type),
                              style: AppTextStyles.labelSm.copyWith(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withValues(alpha: 0.1)),
              ),
              child: Text(
                n.message ?? 'No additional details',
                style: AppTextStyles.bodyMd.copyWith(height: 1.6, color: AppColors.onSurface),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                    label: Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _deleteNotification(n);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.open_in_new_rounded, size: 18),
                    label: const Text(AppStrings.viewDetails),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      _goToRelated(context, n, role);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Swipeable Notification Card
// ═══════════════════════════════════════════════════════════════════════════════

class _SwipeableNotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;
  final VoidCallback onMarkRead;

  const _SwipeableNotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismissed,
    required this.onMarkRead,
  });

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(notification.type);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dismissible(
      key: ValueKey(notification.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.done_all_rounded, color: AppColors.success, size: 24),
            const SizedBox(width: 8),
            Text(AppStrings.read, style: AppTextStyles.labelLg.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(AppStrings.delete, style: AppTextStyles.labelLg.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            Icon(Icons.delete_rounded, color: AppColors.error, size: 24),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onMarkRead();
          return false; // Don't dismiss for mark as read
        }
        return true; // Proceed with dismiss for delete
      },
      onDismissed: (_) => onDismissed(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark
                  ? (notification.isRead ? const Color(0xFF1E2030) : const Color(0xFF1E2240))
                  : (notification.isRead ? Colors.white : AppColors.primary.withValues(alpha: 0.04)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: notification.isRead
                    ? (isDark ? const Color(0xFF2A2D3E) : AppColors.outlineVariant.withValues(alpha: 0.3))
                    : color.withValues(alpha: 0.2),
              ),
              boxShadow: [
                if (!notification.isRead)
                  BoxShadow(
                    color: color.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(_iconForType(notification.type), color: color, size: 24),
                    ),
                    if (!notification.isRead)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF1E2240) : Colors.white,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: AppTextStyles.bodyMd.copyWith(
                                fontWeight: notification.isRead ? FontWeight.w400 : FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeago.format(notification.createdAt),
                            style: AppTextStyles.labelSm.copyWith(
                              color: notification.isRead ? AppColors.onSurfaceVariant : color,
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      if (notification.message != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          notification.message!,
                          style: AppTextStyles.bodySm.copyWith(
                            color: AppColors.onSurfaceVariant,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _labelForType(notification.type),
                          style: AppTextStyles.labelSm.copyWith(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// Helper Functions
// ═══════════════════════════════════════════════════════════════════════════════

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
    case 'direct_note':
      context.push('/notes-history');
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
    case 'direct_note': return Icons.edit_note_rounded;
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
    case 'direct_note': return AppColors.info;
    default: return AppColors.onSurfaceVariant;
  }
}

String _labelForType(String type) {
  switch (type) {
    case 'low_stock': return 'Low Stock';
    case 'target_reached': return 'Target';
    case 'expiry_alert': return 'Expiry';
    case 'appointment_reminder': return 'Appointment';
    case 'product_added': return 'Product Added';
    case 'product_removed': return 'Product Removed';
    case 'visit_flagged': return 'Flagged';
    case 'visit_reviewed': return 'Reviewed';
    case 'expense_approved': return 'Approved';
    case 'expense_rejected': return 'Rejected';
    case 'expense_pending': return 'Pending';
    case 'deactivation_requested': return 'Account';
    case 'direct_note': return 'Note';
    default: return 'Notification';
  }
}
