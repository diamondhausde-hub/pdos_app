import 'package:pdos_app/core/localization/app_strings.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;

import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/local_db/app_database.dart';

class SubmitReportScreen extends ConsumerStatefulWidget {
  const SubmitReportScreen({super.key});

  @override
  ConsumerState<SubmitReportScreen> createState() => _SubmitReportScreenState();
}

class _SubmitReportScreenState extends ConsumerState<SubmitReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  String? _photoPath;
  bool _isSubmitting = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70, // compress to save space
      );
      if (photo != null) {
        setState(() => _photoPath = photo.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    setState(() => _isSubmitting = true);

    try {
      final db = ref.read(appDatabaseProvider);
      final report = LocalFieldReportsCompanion.insert(
        id: const Uuid().v4(),
        repId: user.id,
        content: _contentController.text.trim(),
        photoPath: _photoPath != null ? drift.Value(_photoPath!) : const drift.Value.absent(),
        createdAt: DateTime.now(),
        // synced defaults to false
      );

      await db.into(db.localFieldReports).insert(report);
      
      // Trigger background sync
      ref.read(syncServiceProvider).syncNow();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.generalReportSavedSuccessfully)),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving report: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.submitGeneralReport),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Field Notes',
                style: AppTextStyles.headlineMd,
              ),
              const SizedBox(height: 8),
              Text(
                'Record general observations, competitor activity, or other daily updates that are not tied to a specific visit.',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _contentController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: AppStrings.reportDetails,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                  hintText: AppStrings.typeYourObservationsHere,
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter some details' : null,
              ),
              const SizedBox(height: 24),
              Text(
                'Photo Attachment (Optional)',
                style: AppTextStyles.headlineSm,
              ),
              const SizedBox(height: 12),
              if (_photoPath != null)
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outline),
                        image: DecorationImage(
                          image: FileImage(File(_photoPath!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.cancel, color: AppColors.onPrimary),
                      onPressed: () => setState(() => _photoPath = null),
                    ),
                  ],
                )
              else
                InkWell(
                  onTap: _takePhoto,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.outline, style: BorderStyle.solid),
                      color: AppColors.surfaceContainer,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_rounded, size: 32, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(AppStrings.tapToTakeA, style: AppTextStyles.bodyMd.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSubmitting
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(AppStrings.submitReport),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
