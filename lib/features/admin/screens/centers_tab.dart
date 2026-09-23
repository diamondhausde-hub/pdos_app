import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/center_model.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/glass_card.dart';

class AdminCentersTab extends ConsumerStatefulWidget {
  const AdminCentersTab({super.key});

  @override
  ConsumerState<AdminCentersTab> createState() => _AdminCentersTabState();
}

class _AdminCentersTabState extends ConsumerState<AdminCentersTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final centersAsync = ref.watch(centersProvider);
    final usersAsync = ref.watch(usersListProvider);
    final currentUser = ref.watch(currentUserProvider);
    final canManage = currentUser?.role == UserRole.admin || currentUser?.role == UserRole.supervisor;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) =>
                      setState(() => _searchQuery = val.toLowerCase()),
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchCenters,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.onSurfaceVariant,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                ),
              ),
              if (canManage) ...[
                const SizedBox(width: 10),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_business_rounded,
                      color: AppColors.secondary,
                    ),
                    onPressed: () =>
                        _showCreateCenterDialog(usersAsync.value ?? []),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: centersAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(
                'Error: $err',
                style: TextStyle(color: Colors.red),
              ),
            ),
            data: (centers) {
              final filtered = centers.where((c) {
                final nameMatch = c.name.toLowerCase().contains(_searchQuery);
                final regionMatch = (c.region?.toLowerCase() ?? '').contains(
                  _searchQuery,
                );
                return nameMatch || regionMatch;
              }).toList();

              if (filtered.isEmpty) {
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
                        child: Icon(
                          Icons.store_rounded,
                          size: 28,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No centers found',
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final center = filtered[index];
                  final users = usersAsync.value ?? [];
                  final assignedUser = users
                      .where((u) => u.id == center.assignedRepId)
                      .firstOrNull;
                  final isUnassigned = assignedUser == null;

                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 30,
                      child: FadeInAnimation(
                        child: GlassCard(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          onTap: () => _showCenterDetails(center, assignedUser),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 52, height: 52,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(Icons.store_rounded, color: AppColors.secondary),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(center.name, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on_rounded, size: 12, color: AppColors.onSurfaceVariant),
                                            const SizedBox(width: 4),
                                            Text(center.region ?? 'No Region', style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isUnassigned ? AppColors.warning.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.person_outline, size: 12, color: isUnassigned ? AppColors.warning : AppColors.success),
                                                  const SizedBox(width: 4),
                                                  Text(isUnassigned ? 'Unassigned' : assignedUser.fullName,
                                                      style: AppTextStyles.labelSm.copyWith(color: isUnassigned ? AppColors.warning : AppColors.success)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (canManage)
                                    Container(
                                      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
                                      child: PopupMenuButton(
                                        icon: Icon(Icons.more_vert_rounded, color: AppColors.onSurfaceVariant, size: 20),
                                        itemBuilder: (ctx) => [
                                          const PopupMenuItem(value: 'edit', child: Text(AppStrings.edit)),
                                          const PopupMenuItem(value: 'delete', child: Text(AppStrings.delete)),
                                        ],
                                        onSelected: (val) async {
                                          if (val == 'edit') {
                                            _showCreateCenterDialog(users, center: center);
                                          } else if (val == 'delete') {
                                            try {
                                              await ref.read(centerRepositoryProvider).deleteCenter(center.id);
                                              ref.invalidate(centersProvider);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${center.name} deleted')));
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildCenterStatusBadge(center.status),
                                  const Spacer(),
                                  Text(center.status[0].toUpperCase() + center.status.substring(1),
                                      style: AppTextStyles.labelSm.copyWith(color: _statusColor(center.status))),
                                ],
                              ),
                              if (center.status == 'rejected' && center.rejectionReason != null) ...[
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 14, color: AppColors.error),
                                      const SizedBox(width: 6),
                                      Expanded(child: Text(center.rejectionReason!, style: AppTextStyles.bodySm.copyWith(color: AppColors.error))),
                                    ],
                                  ),
                                ),
                              ],
                              if (center.status == 'pending' && canManage) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 36,
                                        child: OutlinedButton.icon(
                                          onPressed: () => _rejectCenter(center.id, center.name),
                                          icon: Icon(Icons.close, size: 16),
                                          label: Text(AppStrings.reject, style: TextStyle(fontSize: 13)),
                                          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: SizedBox(
                                        height: 36,
                                        child: ElevatedButton.icon(
                                          onPressed: () => _approveCenter(center.id, center.name),
                                          icon: Icon(Icons.check, size: 16),
                                          label: Text(AppStrings.approve, style: TextStyle(fontSize: 13)),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
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

  void _showCenterDetails(CenterModel center, UserModel? assignedUser) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg(Theme.of(context).brightness == Brightness.dark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
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
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.store_rounded, color: AppColors.secondary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(center.name, style: AppTextStyles.h2),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildCenterStatusBadge(center.status),
                            const SizedBox(width: 6),
                            Text(
                              center.status[0].toUpperCase() + center.status.substring(1),
                              style: AppTextStyles.labelMedium.copyWith(color: _statusColor(center.status)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(AppStrings.centerDetails, style: AppTextStyles.h4),
              const SizedBox(height: 16),
              _DetailRow(label: AppStrings.region, value: center.region ?? 'N/A'),
              _DetailRow(label: AppStrings.address, value: center.address ?? 'N/A'),
              _DetailRow(label: AppStrings.latitude, value: center.latitude?.toString() ?? 'N/A'),
              _DetailRow(label: AppStrings.longitude, value: center.longitude?.toString() ?? 'N/A'),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Text(AppStrings.assignmentDetails, style: AppTextStyles.h4),
              const SizedBox(height: 16),
              _DetailRow(
                label: AppStrings.assignedRep, 
                value: assignedUser?.fullName ?? 'Unassigned',
                valueColor: assignedUser == null ? AppColors.warning : AppColors.onSurface,
              ),
              if (center.status == 'rejected' && center.rejectionReason != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text(AppStrings.rejectionReason, style: AppTextStyles.h4.copyWith(color: AppColors.error)),
                const SizedBox(height: 8),
                Text(center.rejectionReason!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
              ],
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'pending': color = AppColors.warning; break;
      case 'rejected': color = AppColors.error; break;
      default: color = AppColors.success;
    }
    return Container(
      width: 8, height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending': return AppColors.warning;
      case 'rejected': return AppColors.error;
      default: return AppColors.success;
    }
  }

  Future<void> _approveCenter(String centerId, String name) async {
    try {
      await ref.read(centerRepositoryProvider).approveCenter(centerId, 'active');
      ref.invalidate(centersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name approved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _rejectCenter(String centerId, String name) async {
    final reasonCtrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.rejectCenter),
        content: TextField(
          controller: reasonCtrl,
          decoration: const InputDecoration(
            hintText: AppStrings.reasonForRejection,
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.cancel)),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, reasonCtrl.text.trim()),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: Text(AppStrings.reject),
          ),
        ],
      ),
    );
    reasonCtrl.dispose();
    if (result == null || result.isEmpty) return;
    try {
      await ref.read(centerRepositoryProvider).approveCenter(centerId, 'rejected', rejectionReason: result);
      ref.invalidate(centersProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name rejected')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showCreateCenterDialog(List<UserModel> users, {CenterModel? center}) {
    final nameCtrl = TextEditingController(text: center?.name);
    final regionCtrl = TextEditingController(text: center?.region);
    final addressCtrl = TextEditingController(text: center?.address);
    final latCtrl = TextEditingController(text: center?.latitude?.toString());
    final lonCtrl = TextEditingController(text: center?.longitude?.toString());
    String? selectedRepId = center?.assignedRepId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cardBg(Theme.of(context).brightness == Brightness.dark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            center == null ? 'Add New Center' : 'Edit Center',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.onSurface,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.centerName,
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: regionCtrl,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.region,
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: addressCtrl,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.address,
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: latCtrl,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: AppTextStyles.bodyMd,
                        decoration: InputDecoration(
                          labelText: AppStrings.latitude,
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: lonCtrl,
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: AppTextStyles.bodyMd,
                        decoration: InputDecoration(
                          labelText: AppStrings.longitude,
                          filled: true,
                          fillColor: AppColors.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  decoration: InputDecoration(
                    labelText: AppStrings.assignedRep,
                    filled: true,
                    fillColor: AppColors.surfaceContainer,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  initialValue: selectedRepId,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text(AppStrings.unassigned),
                    ),
                    ...users.map(
                      (u) => DropdownMenuItem(
                        value: u.id,
                        child: Text(u.fullName),
                      ),
                    ),
                  ],
                  onChanged: (val) => setDialogState(() => selectedRepId = val),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                try {
                  if (center == null) {
                    final newCenter = CenterModel(
                      id: const Uuid().v4(),
                      name: nameCtrl.text.trim(),
                      region: regionCtrl.text.trim().isNotEmpty
                          ? regionCtrl.text.trim()
                          : null,
                      address: addressCtrl.text.trim().isNotEmpty
                          ? addressCtrl.text.trim()
                          : null,
                      latitude: double.tryParse(latCtrl.text),
                      longitude: double.tryParse(lonCtrl.text),
                      assignedRepId: selectedRepId,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    await ref
                        .read(centerRepositoryProvider)
                        .createCenter(newCenter);
                  } else {
                    await ref
                        .read(centerRepositoryProvider)
                        .updateCenter(center.id, {
                          'name': nameCtrl.text.trim(),
                          'region': regionCtrl.text.trim().isNotEmpty
                              ? regionCtrl.text.trim()
                              : null,
                          'address': addressCtrl.text.trim().isNotEmpty
                              ? addressCtrl.text.trim()
                              : null,
                          'latitude': double.tryParse(latCtrl.text),
                          'longitude': double.tryParse(lonCtrl.text),
                          'assigned_rep_id': selectedRepId,
                        });
                  }
                  ref.invalidate(centersProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        center == null ? 'Center added' : 'Center updated',
                      ),
                    ),
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              },
              child: Text(AppStrings.save),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
