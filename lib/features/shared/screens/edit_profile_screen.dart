import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/api_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _regionCtrl;
  File? _newImage;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameCtrl = TextEditingController(text: user?.fullName ?? '');
    _phoneCtrl = TextEditingController(text: user?.phone ?? '');
    _regionCtrl = TextEditingController(text: user?.region ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _regionCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    if (picked == null) return;
    final compressed = await FlutterImageCompress.compressAndGetFile(
      picked.path,
      '${picked.path}_compressed.jpg',
      quality: 70,
      minWidth: 400,
      minHeight: 400,
    );
    if (compressed != null) {
      setState(() => _newImage = File(compressed.path));
    }
  }

  void _showImagePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldBg(isDark),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ImageOption(
              icon: Icons.camera_alt_rounded,
              label: AppStrings.camera,
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.camera); },
            ),
            _ImageOption(
              icon: Icons.photo_library_rounded,
              label: AppStrings.gallery,
              onTap: () { Navigator.pop(ctx); _pickImage(ImageSource.gallery); },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.nameIsRequired), backgroundColor: AppColors.error),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      String? imageUrl;

      if (_newImage != null) {
        final user = ref.read(currentUserProvider);
        if (user != null) {
          final formData = FormData.fromMap({
            'file': await MultipartFile.fromFile(_newImage!.path),
          });
          final response = await ApiService.instance.dio.post(
            '/users/${user.id}/upload-photo',
            data: formData,
          );
          imageUrl = response.data['profile_image_url'] as String?;
          ref.invalidate(authNotifierProvider);
        }
      }

      await ref.read(authNotifierProvider.notifier).updateProfile(
        fullName: name,
        phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
        region: _regionCtrl.text.trim().isEmpty ? null : _regionCtrl.text.trim(),
        profileImageUrl: imageUrl,
      );

      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.profileUpdated), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(AppStrings.editProfile),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImagePicker,
              child: Stack(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      boxShadow: AppColors.glowShadow,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: _newImage != null
                          ? Image.file(_newImage!, fit: BoxFit.cover)
                          : user?.fullProfileImageUrl != null
                              ? Image.network(user!.fullProfileImageUrl!, fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) => _buildInitials(user))
                              : _buildInitials(user),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.scaffoldBg(isDark), width: 3),
                      ),
                      child: Icon(Icons.camera_alt_rounded, color: AppColors.onPrimary, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _nameCtrl,
              style: AppTextStyles.bodyMd,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: AppStrings.fullName_10,
                prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.onSurfaceVariant),
                filled: true, fillColor: AppColors.inputFill(isDark),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _phoneCtrl,
              style: AppTextStyles.bodyMd,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: AppStrings.phone,
                prefixIcon: Icon(Icons.phone_rounded, color: AppColors.onSurfaceVariant),
                filled: true, fillColor: AppColors.inputFill(isDark),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),

            Autocomplete<String>(
              optionsBuilder: (textEditingValue) {
                final query = textEditingValue.text.toLowerCase();
                if (query.isEmpty) return AppConstants.iraqGovernates;
                return AppConstants.iraqGovernates.where((g) => g.toLowerCase().contains(query));
              },
              initialValue: TextEditingValue(text: user?.region ?? ''),
              onSelected: (value) => _regionCtrl.text = value,
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                _regionCtrl = controller;
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  style: AppTextStyles.bodyMd,
                  decoration: InputDecoration(
                    labelText: AppStrings.region,
                    prefixIcon: Icon(Icons.location_on_rounded, color: AppColors.onSurfaceVariant),
                    suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: AppColors.onSurfaceVariant),
                    filled: true, fillColor: AppColors.inputFill(isDark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isSaving
                    ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.onPrimary))
                    : Text(AppStrings.saveChanges, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitials(dynamic user) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: Center(
        child: Text(
          (user?.fullName ?? 'U').substring(0, 1).toUpperCase(),
          style: TextStyle(color: AppColors.onPrimary, fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _ImageOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ImageOption({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.cardBg(isDark),
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
