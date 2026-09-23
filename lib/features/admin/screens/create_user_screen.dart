import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/widgets/glass_card.dart';

class CreateUserScreen extends ConsumerStatefulWidget {
  const CreateUserScreen({super.key});

  @override
  ConsumerState<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends ConsumerState<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String _selectedRole = 'rep';
  String? _selectedBrandId;
  String? _selectedRegion;
  String? _selectedSupervisor;
  bool _isLoading = false;

  // Supervisors will be fetched dynamically based on selected brand

  final _tempPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _tempPasswordCtrl.dispose();
    super.dispose();
  }

  void _generatePassword() {
    // Generate a simple 8-character password
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$';
    final random = (List.generate(
      8,
      (index) =>
          chars[(DateTime.now().microsecondsSinceEpoch + index) % chars.length],
    )).join();
    _tempPasswordCtrl.text = random;
  }

  Future<void> _createUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tempPasswordCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.pleaseEnterOrGenerate),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final role = UserRole.fromString(_selectedRole);
      final tempPass = _tempPasswordCtrl.text.trim();

      await ref
          .read(userRepositoryProvider)
          .createUser(
            email: _emailCtrl.text.trim(),
            fullName: _nameCtrl.text.trim(),
            role: role,
            temporaryPassword: tempPass,
            phone: _phoneCtrl.text.trim().isEmpty
                ? null
                : _phoneCtrl.text.trim(),
            region: _selectedRegion,
            supervisorId: _selectedSupervisor,
          );

      ref.invalidate(usersListProvider);

      if (mounted) {
        setState(() => _isLoading = false);

        // Show success dialog with the password
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(AppStrings.userCreatedSuccessfully),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${_nameCtrl.text.trim()}'),
                const SizedBox(height: 8),
                Text(
                  'Temporary Password: $tempPass',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Send this password securely to the user. They will be prompted to change it upon first login.',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx); // close dialog
                  context.pop(); // close screen
                },
                child: Text(AppStrings.ok),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create user: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.secondary.withValues(alpha: 0.05),
              AppColors.surface.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text(AppStrings.createNewUser),
              actions: [
                TextButton.icon(
                  onPressed: _isLoading ? null : _createUser,
                  icon: _isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.check),
                  label: Text(AppStrings.save),
                ),
              ],
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 48,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Section: Basic Info
                            _SectionHeader(
                              title: AppStrings.basicInformation,
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(
                                labelText: AppStrings.fullName,
                                prefixIcon: Icon(Icons.badge_outlined),
                                hintText: AppStrings.eGAhmedAli,
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Name is required'
                                  : null,
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: AppStrings.emailAddress,
                                prefixIcon: Icon(Icons.email_outlined),
                                hintText: AppStrings.userCompanyCom,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!v.contains('@') || !v.contains('.')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            TextFormField(
                              controller: _phoneCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                labelText: AppStrings.phoneNumber,
                                prefixIcon: Icon(Icons.phone_outlined),
                                hintText: AppStrings.lbl_964XxxXxxXxxx_9,
                              ),
                            ),
                            const SizedBox(height: 16),

                            const SizedBox(height: 32),

                            // Section: Security
                            _SectionHeader(title: AppStrings.security, icon: Icons.lock),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _tempPasswordCtrl,
                                    decoration: const InputDecoration(
                                      labelText: AppStrings.temporaryPassword,
                                      prefixIcon: Icon(Icons.key),
                                      hintText: AppStrings.enterOrGenerate,
                                    ),
                                    validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ElevatedButton.icon(
                                    onPressed: _generatePassword,
                                    icon: Icon(Icons.autorenew),
                                    label: Text(AppStrings.generate),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Section: Role & Assignment
                            _SectionHeader(
                              title: AppStrings.roleAssignment,
                              icon: Icons.assignment_ind,
                            ),
                            const SizedBox(height: 16),

                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              itemHeight: 64,
                              initialValue: _selectedRole,
                              decoration: const InputDecoration(
                                labelText: AppStrings.role,
                                prefixIcon: Icon(Icons.security),
                              ),
                              selectedItemBuilder: (BuildContext context) {
                                return [
                                  _roleSelectedItem('Sales Rep', AppColors.repColor),
                                  _roleSelectedItem('Supervisor', AppColors.supervisorColor),
                                  _roleSelectedItem('General Manager', const Color(0xFF6366F1)),
                                  _roleSelectedItem('Admin', AppColors.adminColor),
                                ];
                              },
                              items: [
                                _roleDropdownItem(
                                  'rep',
                                  'Sales Rep',
                                  'Field visits & sales',
                                  AppColors.repColor,
                                ),
                                _roleDropdownItem(
                                  'supervisor',
                                  'Supervisor',
                                  'Team & inventory management',
                                  AppColors.supervisorColor,
                                ),
                                _roleDropdownItem(
                                  'general_manager',
                                  'General Manager',
                                  'Cross-brand & business management',
                                  const Color(0xFF6366F1), // Indigo
                                ),
                                _roleDropdownItem(
                                  'admin',
                                  'Admin',
                                  'System settings & user accounts',
                                  AppColors.adminColor,
                                ),
                              ],
                              onChanged: (val) =>
                                  setState(() {
                                    _selectedRole = val ?? 'rep';
                                    if (_selectedRole == 'admin' || _selectedRole == 'general_manager') {
                                      _selectedBrandId = null;
                                    }
                                  }),
                            ),
                            const SizedBox(height: 16),

                            // Brand selector
                            if (_selectedRole == 'rep' || _selectedRole == 'supervisor') ...[
                              Consumer(
                                builder: (context, ref, _) {
                                  final brandsAsync = ref.watch(brandsProvider);
                                  return brandsAsync.when(
                                    data: (brands) {
                                      // Default to first brand if only 1 exists, or if none selected
                                      if (brands.length == 1 && _selectedBrandId == null) {
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (mounted) setState(() => _selectedBrandId = brands.first.id);
                                        });
                                      }
                                      
                                      return DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        initialValue: _selectedBrandId,
                                        decoration: const InputDecoration(
                                          labelText: AppStrings.brand,
                                          prefixIcon: Icon(Icons.storefront_rounded),
                                        ),
                                        items: brands.map((b) => DropdownMenuItem(
                                          value: b.id,
                                          child: Text(b.name),
                                        )).toList(),
                                        onChanged: (val) => setState(() => _selectedBrandId = val),
                                        validator: (v) {
                                          if ((_selectedRole == 'rep' || _selectedRole == 'supervisor') && v == null) {
                                            return 'Brand is required for this role';
                                          }
                                          return null;
                                        },
                                      );
                                    },
                                    loading: () => Center(child: CircularProgressIndicator()),
                                    error: (_, _) => Text(AppStrings.errorLoadingBrands, style: TextStyle(color: Colors.red)),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Region selector
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              initialValue: _selectedRegion,
                              decoration: const InputDecoration(
                                labelText: AppStrings.region,
                                prefixIcon: Icon(Icons.map_outlined),
                              ),
                              items: AppConstants.iraqGovernates
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) =>
                                  setState(() => _selectedRegion = val),
                              validator: (v) {
                                if (_selectedRole != 'general_manager' &&
                                    _selectedRole != 'admin' &&
                                    v == null) {
                                  return 'Region is required for this role';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Supervisor assignment (only for Reps)
                            if (_selectedRole == 'rep' && _selectedBrandId != null) ...[
                              Consumer(
                                builder: (context, ref, _) {
                                  final supsAsync = ref.watch(brandSupervisorsProvider(_selectedBrandId!));
                                  return supsAsync.when(
                                    data: (sups) {
                                      if (sups.isEmpty) {
                                        return Text(AppStrings.noSupervisorsAvailableIn, style: TextStyle(color: Colors.red));
                                      }
                                      return DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        initialValue: _selectedSupervisor,
                                        decoration: const InputDecoration(
                                          labelText: AppStrings.assignToSupervisor,
                                          prefixIcon: Icon(Icons.supervisor_account),
                                        ),
                                        items: sups
                                            .map(
                                              (s) => DropdownMenuItem(
                                                value: s.id,
                                                child: Text(s.fullName),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) =>
                                            setState(() => _selectedSupervisor = val),
                                      );
                                    },
                                    loading: () => const CircularProgressIndicator(),
                                    error: (_, _) => Text(AppStrings.errorLoadingSupervisors),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ] else if (_selectedRole == 'rep' && _selectedBrandId == null) ...[
                              Text(AppStrings.pleaseSelectABrand, style: TextStyle(color: AppColors.onSurfaceVariant)),
                              const SizedBox(height: 16),
                            ],

                            const SizedBox(height: 16),

                            // Permissions Preview
                            _SectionHeader(
                              title: AppStrings.permissionsPreview,
                              icon: Icons.shield,
                            ),
                            const SizedBox(height: 16),
                            _PermissionsPreview(role: _selectedRole),

                            const SizedBox(height: 32),

                            // Create Button
                            ElevatedButton.icon(
                              onPressed: _isLoading ? null : _createUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.adminColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              icon: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: AppColors.onPrimary,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Icon(Icons.person_add),
                              label: Text(
                                _isLoading
                                    ? 'Creating...'
                                    : 'Create User & Send Invite',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'A verification email will be sent to the user with login instructions.',
                              style: AppTextStyles.caption,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> _roleDropdownItem(
    String value,
    String title,
    String subtitle,
    Color color,
  ) {
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                Text(
                  subtitle,
                  style: AppTextStyles.caption,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleSelectedItem(String title, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.labelLarge),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.adminColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.h3.copyWith(color: AppColors.adminColor),
        ),
      ],
    );
  }
}

class _PermissionsPreview extends StatelessWidget {
  final String role;

  const _PermissionsPreview({required this.role});

  @override
  Widget build(BuildContext context) {
    final perms = _getPermissions(role);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.zero,
      child: Column(
        children: perms.entries
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      entry.value ? Icons.check_circle : Icons.cancel,
                      size: 18,
                      color: entry.value ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    Text(entry.key, style: AppTextStyles.bodyMd),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Map<String, bool> _getPermissions(String role) {
    switch (role) {
      case 'admin':
        return {
          'Create & manage users': true,
          'Full CRUD on all data': true,
          'View all regions & reports': true,
          'Export data (PDF/Excel/CSV)': true,
          'System configuration': true,
        };
      case 'general_manager':
        return {
          'View all brands & reports': true,
          'View all users & activity': true,
          'Create or edit data': false,
          'Manage users': false,
          'System configuration': false,
        };
      case 'supervisor':
        return {
          'Manage assigned team': true,
          'Edit inventory & products': true,
          'View team reports': true,
          'View other regions': false,
          'Manage users': false,
        };
      default: // rep
        return {
          'View assigned products': true,
          'Log visits & orders': true,
          'View own targets': true,
          'Edit inventory': false,
          'View other reps\' data': false,
        };
    }
  }
}
