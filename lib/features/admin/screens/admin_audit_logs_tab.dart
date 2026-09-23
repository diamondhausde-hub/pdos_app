import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/audit_logs_provider.dart';

class AdminAuditLogsTab extends ConsumerStatefulWidget {
  const AdminAuditLogsTab({super.key});

  @override
  ConsumerState<AdminAuditLogsTab> createState() => _AdminAuditLogsTabState();
}

class _AdminAuditLogsTabState extends ConsumerState<AdminAuditLogsTab> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      ref.read(auditLogsProvider.notifier).loadLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final logsState = ref.watch(auditLogsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Audit Logs'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: logsState.when(
        data: (logs) {
          if (logs.isEmpty) {
            return const Center(child: Text('No audit logs available'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(auditLogsProvider.notifier).loadLogs(isRefresh: true),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: logs.length + (ref.read(auditLogsProvider.notifier).hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == logs.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final log = logs[index];
                final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(log.createdAt);

                IconData icon;
                Color iconColor;

                switch (log.logType) {
                  case 'visit':
                    icon = Icons.flag_rounded;
                    iconColor = AppColors.success;
                    break;
                  case 'user':
                    icon = Icons.person_rounded;
                    iconColor = AppColors.info;
                    break;
                  case 'system':
                    icon = Icons.settings_rounded;
                    iconColor = AppColors.warning;
                    break;
                  case 'alert':
                    icon = Icons.warning_rounded;
                    iconColor = AppColors.error;
                    break;
                  case 'order':
                    icon = Icons.shopping_cart_rounded;
                    iconColor = AppColors.primary;
                    break;
                  default:
                    icon = Icons.info_rounded;
                    iconColor = AppColors.onSurfaceVariant;
                }

                return GlassCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.action,
                              style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'By: ${log.userName}',
                              style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateStr,
                              style: AppTextStyles.caption.copyWith(color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error loading logs', style: AppTextStyles.headlineSm),
              Text(err.toString(), style: AppTextStyles.bodySm),
              TextButton(
                onPressed: () => ref.read(auditLogsProvider.notifier).loadLogs(isRefresh: true),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
