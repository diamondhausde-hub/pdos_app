import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/api_service.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/models/user_model.dart';

class PublicProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  const PublicProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<PublicProfileScreen> createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends ConsumerState<PublicProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final response = await ApiService.instance.dio.get('/users/${widget.userId}/public-profile');
      if (mounted) setState(() { _profile = response.data as Map<String, dynamic>; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = '$e'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.profile),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _buildProfile(),
    );
  }

  Widget _buildProfile() {
    final p = _profile!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 100, height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle, gradient: AppColors.primaryGradient,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: p['profile_image_url'] != null
                  ? Image.network(
                      p['profile_image_url'].toString().startsWith('http') 
                          ? p['profile_image_url'] 
                          : '${ApiService.instance.dio.options.baseUrl}${p['profile_image_url']}', 
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _initials(p['full_name'] ?? 'U')
                    )
                  : _initials(p['full_name'] ?? 'U'),
            ),
          ),
          const SizedBox(height: 16),
          Text(p['full_name'] ?? '', style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.onSurface, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_roleName(p['role'] ?? ''), style: AppTextStyles.labelLg.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 32),

          // Team info
          if ((p['team_count'] ?? 0) > 0)
            _StatCard(Icons.group_rounded, 'Team Size', '${p['team_count']} members'),
          // Supervisor info (for rep viewing their supervisor)
          if (p['supervisor_id'] != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _StatCard(Icons.person_rounded, 'Supervisor', 'Assigned'),
            ),

          const SizedBox(height: 24),
          // Achievements section
          Row(
            children: [
              Icon(Icons.emoji_events_outlined, size: 18, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(AppStrings.achievements, style: AppTextStyles.headlineSm.copyWith(
                color: AppColors.onSurface, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),

          _StatCard(Icons.check_circle_outline, 'Completed Visits', '${p['completed_visits'] ?? 0} visits'),
          const SizedBox(height: 12),
          _StatCard(Icons.track_changes_outlined, 'Target Achievement', '${p['target_achievement_pct'] ?? 0}%'),

          if (_canSendNote(p)) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: FilledButton.icon(
                icon: Icon(Icons.edit_note_rounded, size: 20),
                label: Text(AppStrings.lbl_57),
                onPressed: () => _showSendNoteDialog(p),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _canSendNote(Map<String, dynamic> p) {
    final me = ref.read(currentUserProvider);
    if (me == null) return false;
    final targetRole = p['role'] ?? '';
    if (me.role == UserRole.admin || me.role == UserRole.generalManager) {
      return targetRole == 'rep' || targetRole == 'supervisor';
    }
    if (me.role == UserRole.supervisor) {
      return targetRole == 'rep' && p['supervisor_id'] == me.id;
    }
    return false;
  }

  void _showSendNoteDialog(Map<String, dynamic> p) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Send note to ${p['full_name'] ?? ''}', style: AppTextStyles.h4),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: AppStrings.lbl_60,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppStrings.lbl_15)),
          FilledButton(
            onPressed: () async {
              final content = controller.text.trim();
              if (content.isEmpty) return;
              Navigator.pop(ctx);
              try {
                await ref.read(repNoteRepositoryProvider).sendNote(widget.userId, content);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.lbl_58)));
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send note: $e')));
                }
              }
            },
            child: Text(AppStrings.lbl_59),
          ),
        ],
      ),
    );
  }

  Widget _initials(String name) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : 'U',
        style: TextStyle(color: AppColors.onPrimary, fontSize: 36, fontWeight: FontWeight.bold),
      )),
    );
  }

  String _roleName(String role) {
    switch (role) {
      case 'admin': return 'System Admin';
      case 'general_manager': return 'General Manager';
      case 'supervisor': return 'Supervisor';
      case 'rep': return 'Sales Rep';
      default: return 'User';
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon; final String label; final String value;
  const _StatCard(this.icon, this.label, this.value);
  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 22, color: AppColors.primary),
        ),
        const SizedBox(width: 14),
        Text(label, style: AppTextStyles.labelLg.copyWith(color: AppColors.onSurfaceVariant)),
        const Spacer(),
        Text(value, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
      ]),
    );
  }
}
