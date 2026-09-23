import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../core/theme/theme.dart';
import '../../../core/services/api_service.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/glass_card.dart';
import 'package:dio/dio.dart';

class UploadPhotoScreen extends ConsumerStatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  ConsumerState<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends ConsumerState<UploadPhotoScreen> {
  File? _imageFile;
  bool _isUploading = false;

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
      setState(() => _imageFile = File(compressed.path));
    }
  }

  Future<void> _uploadPhoto() async {
    if (_imageFile == null) return;
    setState(() => _isUploading = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final bytes = await _imageFile!.readAsBytes();
      final fileName = _imageFile!.path.split('/').last;
      
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(bytes, filename: fileName),
      });
      
      final request = ApiService.instance.dio.post(
        '/users/${user.id}/upload-photo',
        data: formData,
      );
      await request;
      ref.invalidate(authNotifierProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: GlassCard(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.primaryGradient,
                        boxShadow: AppColors.glowShadow,
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            )
                          : Icon(
                              Icons.camera_alt_rounded,
                              color: AppColors.onPrimary,
                              size: 52,
                            ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Upload Profile Photo',
                      style: AppTextStyles.displayMd.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a photo to personalize your account',
                      style: AppTextStyles.bodyLg.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _PhotoOption(
                            icon: Icons.camera_alt_rounded,
                            label: AppStrings.camera,
                            onTap: () => _pickImage(ImageSource.camera),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _PhotoOption(
                            icon: Icons.photo_library_rounded,
                            label: AppStrings.gallery,
                            onTap: () => _pickImage(ImageSource.gallery),
                          ),
                        ),
                      ],
                    ),
                    if (_imageFile != null) ...[
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _uploadPhoto,
                          child: _isUploading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: AppColors.onPrimary,
                                  ),
                                )
                              : Text(AppStrings.uploadPhoto),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => ref.read(authNotifierProvider.notifier).updateProfile(profileImageUrl: 'skipped'),
                      child: Text(AppStrings.skipForNow),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _PhotoOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurface),
            ),
          ],
        ),
      ),
    );
  }
}
