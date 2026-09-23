import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/data_providers.dart';
import 'package:pdos_app/core/theme/app_colors.dart';

class NotificationActionIcon extends ConsumerWidget {
  const NotificationActionIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsStreamProvider);

    return notificationsAsync.when(
      data: (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                GoRouter.of(context).push('/notifications');
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
      loading: () => IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => GoRouter.of(context).push('/notifications'),
      ),
      error: (_, _) => IconButton(
        icon: Icon(Icons.notifications),
        onPressed: () => GoRouter.of(context).push('/notifications'),
      ),
    );
  }
}
