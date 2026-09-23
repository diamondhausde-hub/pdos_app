import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';

class GeneralManagerLogsTab extends ConsumerStatefulWidget {
  const GeneralManagerLogsTab({super.key});

  @override
  ConsumerState<GeneralManagerLogsTab> createState() => _GeneralManagerLogsTabState();
}

class _GeneralManagerLogsTabState extends ConsumerState<GeneralManagerLogsTab> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final selectedBrandId = ref.watch(selectedBrandIdProvider);
    final logsAsync = ref.watch(logsProvider(selectedBrandId));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(label: 'All', isSelected: _selectedFilter == 'All', onTap: () => setState(() => _selectedFilter = 'All')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Visits', isSelected: _selectedFilter == 'visit', onTap: () => setState(() => _selectedFilter = 'visit')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Orders', isSelected: _selectedFilter == 'order', onTap: () => setState(() => _selectedFilter = 'order')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Alerts', isSelected: _selectedFilter == 'alert', onTap: () => setState(() => _selectedFilter = 'alert')),
                const SizedBox(width: 8),
                _FilterChip(label: 'Users', isSelected: _selectedFilter == 'user', onTap: () => setState(() => _selectedFilter = 'user')),
              ],
            ),
          ),
        ),
        Expanded(
          child: logsAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Failed to load logs: $err', style: TextStyle(color: AppColors.error)),
              ),
            ),
            data: (logs) {
              final filtered = _selectedFilter == 'All'
                  ? logs
                  : logs.where((l) => l.logType == _selectedFilter).toList();

              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(color: AppColors.surfaceContainer, shape: BoxShape.circle),
                        child: Icon(Icons.history_rounded, size: 28, color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 16),
                      Text('No activity logs yet',
                          style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final log = filtered[index];
                  final icon = _iconForType(log.logType);
                  final color = _colorForType(log.logType);
                  final timeStr = _formatTime(log.createdAt);

                  return GlassCard(
                    padding: const EdgeInsets.all(12),
                    margin: EdgeInsets.zero,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(icon, size: 18, color: color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
                                  children: [
                                    TextSpan(text: '${log.userName} ', style: TextStyle(fontWeight: FontWeight.w600)),
                                    TextSpan(text: log.action),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(timeStr, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'visit': return Icons.directions_walk;
      case 'order': return Icons.shopping_cart;
      case 'alert': return Icons.warning_rounded;
      case 'user': return Icons.person;
      case 'config': return Icons.settings;
      default: return Icons.info_outline;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'visit': return AppColors.accent;
      case 'order': return AppColors.primary;
      case 'alert': return AppColors.warning;
      case 'user': return AppColors.overseerColor;
      case 'config': return AppColors.supervisorColor;
      default: return AppColors.textSecondaryLight;
    }
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.zero,
        customColor: isSelected ? AppColors.primary.withValues(alpha: 0.2) : null,
        child: Text(label, style: AppTextStyles.labelMd.copyWith(
          color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
        )),
      ),
    );
  }
}
