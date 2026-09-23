import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/user_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/brand_provider.dart';
import 'package:go_router/go_router.dart';

class UserManagementTab extends ConsumerStatefulWidget {
  const UserManagementTab({super.key});

  @override
  ConsumerState<UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends ConsumerState<UserManagementTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(usersListProvider);
    final brandsAsync = ref.watch(brandsProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: AppStrings.searchUsers,
                    prefixIcon: Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    filled: true,
                    fillColor: AppColors.surfaceContainerLow,
                  ),
                ),
              ),
              if (currentUser?.role == UserRole.admin) ...[
                const SizedBox(width: 10),
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.adminColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.person_add_rounded, color: AppColors.adminColor),
                    onPressed: () => context.push('/admin/create_user'),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: usersAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: Colors.red))),
            data: (users) {
              final filteredUsers = users.where((u) =>
                u.fullName.toLowerCase().contains(_searchQuery) ||
                u.email.toLowerCase().contains(_searchQuery)).toList();

              if (filteredUsers.isEmpty) {
                return const Center(child: Text(AppStrings.noUsersFound));
              }

              final brands = brandsAsync.asData?.value ?? [];
              final brandMap = {for (var b in brands) b.id: b.name};

              final adminsAndGms = filteredUsers.where((u) => u.role == UserRole.admin || u.role == UserRole.generalManager).toList();
              
              // Group field teams by brand
              final brandGroups = <String, List<UserModel>>{};
              final noBrandReps = <UserModel>[]; // Reps without a brandId

              for (var u in filteredUsers) {
                if (u.role == UserRole.supervisor || u.role == UserRole.rep) {
                  if (u.brandId != null) {
                    brandGroups.putIfAbsent(u.brandId!, () => []).add(u);
                  } else {
                    noBrandReps.add(u);
                  }
                }
              }

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(usersListProvider),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    if (adminsAndGms.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                        child: Text(AppStrings.systemAdminsManagers, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      ...adminsAndGms.map((u) => _buildUserCard(u)),
                      const SizedBox(height: 16),
                    ],
                    
                    ...brandGroups.entries.map((entry) {
                      final brandId = entry.key;
                      final brandName = brandMap[brandId] ?? 'Unknown Brand';
                      final brandUsers = entry.value;
                      
                      final supervisors = brandUsers.where((u) => u.role == UserRole.supervisor).toList();
                      final reps = brandUsers.where((u) => u.role == UserRole.rep).toList();
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.business_rounded, color: AppColors.primary, size: 24),
                                const SizedBox(width: 8),
                                Text(brandName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
                              ],
                            ),
                          ),
                          ...supervisors.map((sup) {
                            final teamReps = reps.where((r) => r.supervisorId == sup.id).toList();
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ExpansionTile(
                                shape: const RoundedRectangleBorder(side: BorderSide.none),
                                leading: CircleAvatar(
                                  backgroundColor: AppColors.supervisorColor.withValues(alpha: 0.2),
                                  child: Icon(Icons.shield, color: AppColors.supervisorColor, size: 20),
                                ),
                                title: Text(sup.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${teamReps.length} Reps', style: TextStyle(color: AppColors.onSurfaceVariant)),
                                children: [
                                  _buildUserCard(sup, isInsideTile: true),
                                  ...teamReps.map((r) => _buildUserCard(r, isInsideTile: true)),
                                ],
                              ),
                            );
                          }),
                          
                          // Reps without a valid supervisor in this brand
                          ...reps.where((r) => !supervisors.any((s) => s.id == r.supervisorId)).map((r) => _buildUserCard(r)),
                        ],
                      );
                    }),
                    
                    if (noBrandReps.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                        child: Text(AppStrings.unassignedNoBrand, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurfaceVariant)),
                      ),
                      ...noBrandReps.map((u) => _buildUserCard(u)),
                    ]
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserModel user, {bool isInsideTile = false}) {
    return Card(
      margin: EdgeInsets.only(bottom: isInsideTile ? 0 : 8, left: isInsideTile ? 16 : 0, right: isInsideTile ? 16 : 0),
      elevation: isInsideTile ? 0 : 1,
      color: isInsideTile ? Colors.transparent : null,
      child: ListTile(
        onTap: () => context.push('/admin/user/${user.id}'),
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: _roleColor(user.role).withValues(alpha: 0.15),
          child: Text(
            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
            style: AppTextStyles.bodyMedium.copyWith(color: _roleColor(user.role)),
          ),
        ),
        title: Text(user.fullName, style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(user.role.displayName),
        trailing: Switch(
          value: user.isActive,
          activeThumbColor: AppColors.success,
          onChanged: (val) async {
            try {
              await ref.read(userRepositoryProvider).updateUser(user.id, {'is_active': val});
              ref.invalidate(usersListProvider);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.fullName} updated')));
              }
            } catch (e) {
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
            }
          },
        ),
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.admin: return AppColors.primary;
      case UserRole.generalManager: return AppColors.secondary;
      case UserRole.overseer: return AppColors.overseerColor;
      case UserRole.supervisor: return AppColors.supervisorColor;
      case UserRole.rep: return AppColors.info;
    }
  }
}
