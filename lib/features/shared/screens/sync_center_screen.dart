import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/sync_status_service.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/theme.dart';

class SyncCenterScreen extends ConsumerStatefulWidget {
  const SyncCenterScreen({super.key});

  @override
  ConsumerState<SyncCenterScreen> createState() => _SyncCenterScreenState();
}

class _SyncCenterScreenState extends ConsumerState<SyncCenterScreen> {
  bool _isSyncing = false;

  Future<void> _forceSync() async {
    setState(() => _isSyncing = true);
    try {
      final orchestrator = ref.read(syncOrchestratorProvider);
      final user = ref.read(authNotifierProvider).user;
      await orchestrator.syncAllInOrder(repId: user?.id);
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
        ref.invalidate(pendingSyncItemsProvider);
        ref.invalidate(pendingSyncCountProvider);
      }
    }
  }

  Future<void> _abandonItem(SyncItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.lbl_61, textAlign: TextAlign.right),
        content: Text(
          'Ignoring this item will stop it from retrying and may result in data loss. The supervisor will be notified. Are you sure?',
          textAlign: TextAlign.left,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.lbl_15)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppStrings.lbl_63, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final syncService = ref.read(syncServiceProvider);
      final user = ref.read(authNotifierProvider).user;
      if (user != null) {
        await syncService.abandonItem(item.type, item.id, user.id);
        ref.invalidate(pendingSyncItemsProvider);
        ref.invalidate(pendingSyncCountProvider);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingItemsAsync = ref.watch(pendingSyncItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.lbl_40),
        actions: [
          if (pendingItemsAsync.asData?.value.isNotEmpty == true)
            IconButton(
              icon: _isSyncing
                  ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.sync),
              onPressed: _isSyncing ? null : _forceSync,
              tooltip: AppStrings.lbl_67,
            ),
        ],
      ),
      body: pendingItemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_done, size: 64, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(AppStrings.lbl_64, style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(AppStrings.lbl_65, style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: AppTextStyles.h4,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.type.toUpperCase(),
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      if (item.error != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error_outline, size: 16, color: AppColors.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.error!,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: () => _abandonItem(item),
                          icon: Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                          label: Text(AppStrings.lbl_66, style: TextStyle(color: AppColors.error)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
