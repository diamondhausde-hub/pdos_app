import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/user_model.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  final String userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  bool _isEditing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late bool _isActive;

  // Mock user data
  late final Map<String, dynamic> _user;

  @override
  void initState() {
    super.initState();
    _user = {
      'name': 'Ahmed Ali',
      'email': 'ahmed@pdos.com',
      'phone': '+964 770 123 4567',
      'role': 'rep',
      'region': 'Baghdad',
      'supervisor': 'Ali Supervisor',
      'active': true,
      'created': '2026-01-15',
      'lastLogin': '2026-07-04 08:30',
      'visitsThisMonth': 38,
      'targetCompletion': 0.76,
      'totalOrders': 142,
      'totalRevenue': 18500,
    };
    _nameCtrl = TextEditingController(text: _user['name']);
    _emailCtrl = TextEditingController(text: _user['email']);
    _phoneCtrl = TextEditingController(text: _user['phone']);
    _isActive = _user['active'];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = UserRole.fromString(_user['role']);
    final roleColor = _getRoleColor(role);

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
              title: Text(_isEditing ? 'Edit User' : 'User Details'),
              actions: [
                if (!_isEditing)
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => setState(() => _isEditing = true),
                  )
                else ...[
                  TextButton(
                    onPressed: () => setState(() => _isEditing = false),
                    child: Text(AppStrings.cancel),
                  ),
                  TextButton.icon(
                    onPressed: _saveChanges,
                    icon: Icon(Icons.check, size: 18),
                    label: Text(AppStrings.save),
                  ),
                ],
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundColor: roleColor.withValues(
                                  alpha: 0.2,
                                ),
                                child: Text(
                                  _user['name']
                                      .toString()
                                      .split(' ')
                                      .map((w) => w[0])
                                      .join(),
                                  style: AppTextStyles.h1.copyWith(
                                    color: roleColor,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: _isActive
                                        ? AppColors.success
                                        : AppColors.error,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.onPrimary,
                                      width: 3,
                                    ),
                                  ),
                                  child: Icon(
                                    _isActive ? Icons.check : Icons.close,
                                    size: 14,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (!_isEditing) ...[
                            Text(_user['name'], style: AppTextStyles.h2),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: roleColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                role.displayName,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: roleColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Editable Fields or Info Cards
                    if (_isEditing) ...[
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: AppStrings.fullName_10,
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(
                          labelText: AppStrings.email,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneCtrl,
                        decoration: const InputDecoration(
                          labelText: AppStrings.phone,
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: Text(AppStrings.accountActive),
                        subtitle: Text(
                          _isActive ? 'User can log in' : 'User is blocked',
                        ),
                        value: _isActive,
                        activeThumbColor: AppColors.success,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ] else ...[
                      // Info Section
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Information',
                              style: AppTextStyles.h4,
                            ),
                            const SizedBox(height: 16),
                            _InfoRow(
                              icon: Icons.email,
                              label: AppStrings.email,
                              value: _user['email'],
                            ),
                            _InfoRow(
                              icon: Icons.phone,
                              label: AppStrings.phone,
                              value: _user['phone'],
                            ),
                            _InfoRow(
                              icon: Icons.map,
                              label: AppStrings.region,
                              value: _user['region'],
                            ),
                            _InfoRow(
                              icon: Icons.supervisor_account,
                              label: AppStrings.supervisor,
                              value: _user['supervisor'],
                            ),
                            _InfoRow(
                              icon: Icons.calendar_today,
                              label: AppStrings.joined,
                              value: _user['created'],
                            ),
                            _InfoRow(
                              icon: Icons.access_time,
                              label: AppStrings.lastLogin,
                              value: _user['lastLogin'],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Stats Section
                      Text(AppStrings.performanceStats, style: AppTextStyles.h4),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatMini(
                              label: AppStrings.visits,
                              value: '${_user['visitsThisMonth']}',
                              icon: Icons.directions_walk,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatMini(
                              label: AppStrings.orders,
                              value: '${_user['totalOrders']}',
                              icon: Icons.shopping_cart,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatMini(
                              label: AppStrings.revenue,
                              value: '\$${_user['totalRevenue']}',
                              icon: Icons.attach_money,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Target progress
                      GlassCard(
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppStrings.monthlyTarget, style: AppTextStyles.h4),
                                Text(
                                  '${((_user['targetCompletion'] as double) * 100).toInt()}%',
                                  style: AppTextStyles.h3.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: _user['targetCompletion'],
                                backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                                color: AppColors.primary,
                                minHeight: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Quick Actions
                      Text(AppStrings.quickActions, style: AppTextStyles.h4),
                      const SizedBox(height: 12),
                      _ActionTile(
                        icon: Icons.lock_reset,
                        title: AppStrings.resetPassword,
                        subtitle:
                            'Force user to set a new password on next login',
                        color: AppColors.warning,
                        onTap: () => _showResetPasswordDialog(),
                      ),
                      if (ref.watch(currentUserProvider)?.role == UserRole.admin)
                        _ActionTile(
                          icon: _isActive ? Icons.block : Icons.check_circle,
                          title: _isActive
                              ? 'Deactivate Account'
                              : 'Activate Account',
                          subtitle: _isActive
                              ? 'Block this user from accessing the system'
                              : 'Re-enable this user\'s access',
                          color: _isActive ? AppColors.error : AppColors.success,
                          onTap: () => _toggleActive(),
                        )
                      else if (ref.watch(currentUserProvider)?.role == UserRole.generalManager && _isActive)
                        _ActionTile(
                          icon: Icons.pan_tool_rounded,
                          title: AppStrings.requestDeactivation,
                          subtitle: AppStrings.notifyAdminToDisable,
                          color: AppColors.error,
                          onTap: () => _requestDeactivation(),
                        ),
                      _ActionTile(
                        icon: Icons.history,
                        title: AppStrings.viewActivityLog,
                        subtitle: AppStrings.seeAllActionsPerformed,
                        color: AppColors.overseerColor,
                        onTap: () => _showActivityLog(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin: return AppColors.primary;
      case UserRole.generalManager: return AppColors.secondary;
      case UserRole.overseer: return AppColors.overseerColor;
      case UserRole.supervisor: return AppColors.supervisorColor;
      case UserRole.rep: return AppColors.info;
    }
  }

  void _saveChanges() {
    setState(() {
      _user['name'] = _nameCtrl.text;
      _user['email'] = _emailCtrl.text;
      _user['phone'] = _phoneCtrl.text;
      _user['active'] = _isActive;
      _isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.userUpdatedSuccessfully),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showResetPasswordDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.resetPassword),
        content: Text(
          'This will force ${_user['name']} to create a new password on their next login.\n\nA temporary password will be generated and sent to their email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Password reset email sent to ${_user['email']}',
                  ),
                ),
              );
            },
            child: Text(AppStrings.resetPassword),
          ),
        ],
      ),
    );
  }

  Future<void> _requestDeactivation() async {
    try {
      final api = ref.read(apiServiceProvider);
      await api.dio.post('/users/${widget.userId}/request-deactivation');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppStrings.deactivationRequestSentTo),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to request deactivation: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _toggleActive() {
    setState(() => _isActive = !_isActive);
    setState(() => _user['active'] = _isActive);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_user['name']} has been ${_isActive ? "activated" : "deactivated"}',
        ),
        backgroundColor: _isActive ? AppColors.success : AppColors.error,
      ),
    );
  }

  void _showActivityLog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        expand: false,
        builder: (ctx, scrollCtrl) => ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 16),
            Text(AppStrings.activityLog, style: AppTextStyles.h3),
            const SizedBox(height: 16),
            _LogItem(
              action: 'Completed visit at Al-Shifa Pharmacy',
              time: 'Today, 08:30 AM',
            ),
            _LogItem(
              action: 'Submitted order #1042 — 200 units',
              time: 'Today, 07:50 AM',
            ),
            _LogItem(
              action: 'Logged in from mobile device',
              time: 'Today, 07:15 AM',
            ),
            _LogItem(
              action: 'Completed visit at City Center Hospital',
              time: 'Yesterday, 04:30 PM',
            ),
            _LogItem(
              action: 'Updated stock levels for Amoxicillin',
              time: 'Yesterday, 02:15 PM',
            ),
            _LogItem(action: 'Password changed', time: 'Jun 30, 2026'),
            _LogItem(action: 'Account created by Admin', time: 'Jan 15, 2026'),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondaryLight),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _StatMini extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatMini({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h4.copyWith(color: color)),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: AppTextStyles.labelLarge),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: Icon(Icons.chevron_right, size: 18),
        onTap: onTap,
      ),
    );
  }
}

class _LogItem extends StatelessWidget {
  final String action;
  final String time;

  const _LogItem({required this.action, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action, style: AppTextStyles.bodyMedium),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

