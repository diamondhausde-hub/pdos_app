import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/widgets/theme_transition_overlay.dart';
import '../../../core/models/user_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/biometric_lock_service.dart';
import '../../../core/widgets/glass_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late TextEditingController _nameCtrl;
  late TextEditingController _currentPwCtrl;
  late TextEditingController _newPwCtrl;
  late TextEditingController _confirmPwCtrl;
  File? _newImage;
  bool _isSaving = false;
  final _lockService = BiometricLockService();
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameCtrl = TextEditingController(text: user?.fullName ?? '');
    _currentPwCtrl = TextEditingController();
    _newPwCtrl = TextEditingController();
    _confirmPwCtrl = TextEditingController();
    _loadBiometricSetting();
  }

  Future<void> _loadBiometricSetting() async {
    final enabled = await _lockService.isEnabled();
    if (mounted) setState(() => _biometricEnabled = enabled);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, maxWidth: 1024, maxHeight: 1024);
    if (picked == null) return;
    final compressed = await FlutterImageCompress.compressAndGetFile(
      picked.path, '${picked.path}_compressed.jpg',
      quality: 70, minWidth: 400, minHeight: 400,
    );
    if (compressed != null) setState(() => _newImage = File(compressed.path));
  }

  void _showImagePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ImageOption(icon: Icons.camera_alt_rounded, label: 'Camera',
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); }),
            _ImageOption(icon: Icons.photo_library_rounded, label: 'Gallery',
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); }),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) { _showError('Name is required'); return; }
    final pw = _newPwCtrl.text;
    if (pw.isNotEmpty) {
      if (_currentPwCtrl.text.isEmpty) { _showError('Current password is required'); return; }
      if (pw.length < 8) { _showError('New password must be at least 8 characters'); return; }
      if (pw != _confirmPwCtrl.text) { _showError('Passwords do not match'); return; }
    }
    setState(() => _isSaving = true);
    try {
      String? photoUrl;
      if (_newImage != null) {
        final user = ref.read(currentUserProvider);
        if (user != null) {
          final formData = FormData.fromMap({'file': await MultipartFile.fromFile(_newImage!.path)});
          final response = await ApiService.instance.dio.post('/users/${user.id}/upload-photo', data: formData);
          photoUrl = response.data['profile_image_url'] as String?;
        }
      }
      await ref.read(profileRepositoryProvider).updateOwnProfile(
        fullName: name, photoUrl: photoUrl,
        currentPassword: pw.isNotEmpty ? _currentPwCtrl.text : null,
        newPassword: pw.isNotEmpty ? pw : null,
      );
      ref.invalidate(currentUserProvider);
      if (mounted) {
        setState(() { _isSaving = false; _isEditing = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated'), backgroundColor: AppColors.success));
      }
    } catch (e) {
      if (mounted) { setState(() => _isSaving = false); _showError('$e'); }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error));
  }

  String _roleName(UserRole? role) {
    if (role == null) return 'User';
    switch (role) {
      case UserRole.admin: return 'System Admin';
      case UserRole.generalManager: return 'General Manager';
      case UserRole.overseer: return 'System Overseer';
      case UserRole.supervisor: return 'Supervisor';
      case UserRole.rep: return 'Sales Rep';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Profile' : 'Profile'),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        actions: _isEditing ? null : [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => setState(() => _isEditing = true)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Avatar ──
            GestureDetector(
              onTap: _isEditing ? _showImagePicker : null,
              child: Stack(
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, gradient: AppColors.primaryGradient,
                      boxShadow: AppColors.glowShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: _newImage != null
                          ? Image.file(_newImage!, fit: BoxFit.cover)
                          : user?.fullProfileImageUrl != null
                              ? Image.network(user!.fullProfileImageUrl!, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _buildInitials(user))
                              : _buildInitials(user),
                    ),
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle,
                          border: Border.all(color: AppColors.scaffoldBg(isDark), width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(user?.fullName ?? 'User', style: AppTextStyles.headlineMd.copyWith(
              color: AppColors.onSurface, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(_roleName(user?.role), style: AppTextStyles.labelLg.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),

            if (!_isEditing) ...[
              // ── Brand ──
              ref.watch(myBrandProvider).when(
                data: (brand) => brand != null
                    ? _InfoRow(Icons.business_rounded, 'Brand', brand.name)
                    : const SizedBox.shrink(),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              // ── Supervisor name (for rep) ──
              if (user?.role == UserRole.rep && user?.supervisorId != null)
                _SupervisorNameLabel(user!.supervisorId!),
              // ── Team count (for supervisor/rep) ──
              if (user?.role == UserRole.supervisor)
                _TeamCount(user!.id),
              if (user?.role == UserRole.rep && user?.supervisorId != null)
                _SiblingCount(user!.supervisorId!),
              _InfoRow(Icons.email_rounded, 'Email', user?.email ?? ''),
              _InfoRow(Icons.phone_rounded, 'Phone', user?.phone ?? 'Not provided'),
              _InfoRow(Icons.location_on_rounded, 'Region', user?.region ?? 'Unassigned'),
              _InfoRow(Icons.calendar_month_rounded, 'Joined',
                user?.createdAt != null ? DateFormat('MMM yyyy').format(user!.createdAt) : 'Unknown'),
              const SizedBox(height: 24),

              // ── Biometric Lock ──
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.fingerprint, size: 20, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Biometric Lock', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    Switch(
                      value: _biometricEnabled,
                      onChanged: (val) async {
                        if (val) {
                          final available = await _lockService.isAvailable();
                          if (!available) {
                            if (!mounted) return;
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Biometric not available on this device'),
                            ));
                            return;
                          }
                        }
                        await _lockService.setEnabled(val);
                        if (mounted) setState(() => _biometricEnabled = val);
                      },
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Theme ──
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(Icons.palette_rounded, size: 20, color: AppColors.primary),
                          const SizedBox(width: 12),
                          Text('Appearance', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    _ThemeOption(
                      icon: Icons.brightness_auto_rounded,
                      label: 'System default',
                      value: ThemeMode.system,
                      groupValue: ref.watch(themeModeProvider),
                      onChanged: (v, origin) {
                        debugPrint('🎨 [THEME] System tapped at $origin');
                        final toDark = v == ThemeMode.dark ||
                            (v == ThemeMode.system &&
                                MediaQuery.platformBrightnessOf(context) == Brightness.dark);
                        ThemeTransitionController.animate(
                          globalOrigin: origin,
                          toDark: toDark,
                          onSwitch: () {
                            debugPrint('🎨 [THEME] onSwitch → system');
                            ref.read(themeModeProvider.notifier).setThemeMode(v);
                          },
                        );
                      },
                    ),
                    _ThemeOption(
                      icon: Icons.light_mode_rounded,
                      label: 'Light',
                      value: ThemeMode.light,
                      groupValue: ref.watch(themeModeProvider),
                      onChanged: (v, origin) {
                        debugPrint('🎨 [THEME] Light tapped at $origin');
                        ThemeTransitionController.animate(
                          globalOrigin: origin,
                          toDark: false,
                          onSwitch: () {
                            debugPrint('🎨 [THEME] onSwitch → light');
                            ref.read(themeModeProvider.notifier).setThemeMode(v);
                          },
                        );
                      },
                    ),
                    _ThemeOption(
                      icon: Icons.dark_mode_rounded,
                      label: 'Dark',
                      value: ThemeMode.dark,
                      groupValue: ref.watch(themeModeProvider),
                      onChanged: (v, origin) {
                        debugPrint('🎨 [THEME] Dark tapped at $origin');
                        ThemeTransitionController.animate(
                          globalOrigin: origin,
                          toDark: true,
                          onSwitch: () {
                            debugPrint('🎨 [THEME] onSwitch → dark');
                            ref.read(themeModeProvider.notifier).setThemeMode(v);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Notes History ──
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_note_rounded, size: 20, color: AppColors.info),
                  ),
                  title: Text('Notes History', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text('Sent and received notes', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                  trailing: Icon(Icons.chevron_left_rounded, color: AppColors.onSurfaceVariant),
                  onTap: () => context.push('/notes-history'),
                ),
              ),
              const SizedBox(height: 12),

              // ── My Signature ──
              GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.draw_rounded, size: 20, color: AppColors.primary),
                  ),
                  title: Text('My Signature', style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text('Manage your default signature', style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant)),
                  trailing: Icon(Icons.chevron_left_rounded, color: AppColors.onSurfaceVariant),
                  onTap: () => context.push('/my_signature'),
                ),
              ),
              const SizedBox(height: 24),

              // ── Logout ──
              SizedBox(
                width: double.infinity, height: 56,
                child: FilledButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Sign Out'),
                        content: const Text('Are you sure you want to sign out?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          FilledButton(
                            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                            onPressed: () { Navigator.pop(ctx); ref.read(authNotifierProvider.notifier).logout(); },
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Sign Out'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.1),
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],

            // ── Edit mode ──
            if (_isEditing) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _nameCtrl,
                style: AppTextStyles.bodyMd,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.onSurfaceVariant),
                  filled: true, fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text('Change Password', style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.onSurfaceVariant, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _currentPwCtrl, obscureText: true, style: AppTextStyles.bodyMd,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_rounded, color: AppColors.onSurfaceVariant),
                  filled: true, fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPwCtrl, obscureText: true, style: AppTextStyles.bodyMd,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.onSurfaceVariant),
                  filled: true, fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPwCtrl, obscureText: true, style: AppTextStyles.bodyMd,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.onSurfaceVariant),
                  filled: true, fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                ),
              ),
              if (_newPwCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity, padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Requirements:', style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurface)),
                      const SizedBox(height: 8),
                      _ReqRow(text: 'At least 8 characters', isMet: _newPwCtrl.text.length >= 8),
                      _ReqRow(text: 'One uppercase letter', isMet: _newPwCtrl.text.contains(RegExp(r'[A-Z]'))),
                      _ReqRow(text: 'One number', isMet: _newPwCtrl.text.contains(RegExp(r'[0-9]'))),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => setState(() { _isEditing = false; _newImage = null; }),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isSaving ? null : _save,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          : const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInitials(dynamic user) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(child: Text(
        (user?.fullName ?? 'U').substring(0, 1).toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
      )),
    );
  }
}

// ── Info row ──

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _InfoRow(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text('$label: ', style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
          Expanded(child: Text(value, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface))),
        ]),
      ),
    );
  }
}

// ── Supervisor name lookup ──

class _SupervisorNameLabel extends ConsumerWidget {
  final String supervisorId;
  const _SupervisorNameLabel(this.supervisorId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);
    return usersAsync.when(
      data: (users) {
        final sup = users.where((u) => u.id == supervisorId).firstOrNull;
        return _InfoRow(Icons.person_rounded, 'Supervisor', sup?.fullName ?? 'Unknown');
      },
      loading: () => _InfoRow(Icons.person_rounded, 'Supervisor', 'Loading...'),
      error: (_, _) => _InfoRow(Icons.person_rounded, 'Supervisor', 'Unknown'),
    );
  }
}

// ── Team count for a supervisor ──

class _TeamCount extends ConsumerWidget {
  final String userId;
  const _TeamCount(this.userId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);
    return usersAsync.when(
      data: (users) {
        final team = users.where((u) => u.supervisorId == userId && u.role == UserRole.rep).toList();
        if (team.isEmpty) return const SizedBox.shrink();
        return _InfoRow(Icons.group_rounded, 'Team', '${team.length} members');
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// ── Sibling count (rep seeing how many peers on same supervisor) ──

class _SiblingCount extends ConsumerWidget {
  final String supervisorId;
  const _SiblingCount(this.supervisorId);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersListProvider);
    return usersAsync.when(
      data: (users) {
        final siblings = users.where((u) => u.supervisorId == supervisorId && u.role == UserRole.rep).toList();
        if (siblings.isEmpty) return const SizedBox.shrink();
        return _InfoRow(Icons.people_outline_rounded, 'Team Size', '${siblings.length} members');
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

// ── Image picker option ──

class _ImageOption extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap;
  const _ImageOption({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110, height: 110,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface)),
          ],
        ),
      ),
    );
  }
}

// ── Password requirement row ──

class _ReqRow extends StatelessWidget {
  final String text; final bool isMet;
  const _ReqRow({required this.text, required this.isMet});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Icon(isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 18,
          color: isMet ? AppColors.success : AppColors.outlineVariant),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodySm.copyWith(color: isMet ? AppColors.success : AppColors.onSurfaceVariant)),
      ]),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final ThemeMode value;
  final ThemeMode groupValue;
  final void Function(ThemeMode value, Offset tapOrigin) onChanged;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) {
        if (!selected) {
          onChanged(value, details.globalPosition);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label, style: AppTextStyles.bodyMd.copyWith(
                color: selected ? AppColors.primary : AppColors.onSurface,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              )),
            ),
            Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.outlineVariant,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10, height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
