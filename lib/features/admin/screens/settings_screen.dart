import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/system_setting.dart';
import '../../../core/widgets/glass_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _geoRadiusCtrl = TextEditingController();
  final _neglectDaysCtrl = TextEditingController();
  final _maxPhotosCtrl = TextEditingController();
  final _hardRejectCtrl = TextEditingController();
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void dispose() {
    _geoRadiusCtrl.dispose();
    _neglectDaysCtrl.dispose();
    _maxPhotosCtrl.dispose();
    _hardRejectCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isSaving = true; _errorMessage = null; });
    try {
      final svc = ref.read(settingsServiceProvider);
      final geoVal = double.tryParse(_geoRadiusCtrl.text);
      if (geoVal != null) await svc.updateSetting('geofence_radius_meters', geoVal);
      final neglectVal = double.tryParse(_neglectDaysCtrl.text);
      if (neglectVal != null) await svc.updateSetting('coverage_neglect_days', neglectVal);
      final photosVal = double.tryParse(_maxPhotosCtrl.text);
      if (photosVal != null) await svc.updateSetting('max_shelf_photos_per_visit', photosVal);
      final hardRejectVal = double.tryParse(_hardRejectCtrl.text);
      if (hardRejectVal != null) await svc.updateSetting('geofence_hard_reject_meters', hardRejectVal);
      ref.invalidate(settingsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.settingsSavedSuccessfully), backgroundColor: AppColors.success),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppStrings.systemSettings),
      ),
      body: settingsAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (settings) {
          if (_geoRadiusCtrl.text.isEmpty) {
            final geo = settings.firstWhere(
              (s) => s.key == 'geofence_radius_meters',
              orElse: () => SystemSettingModel(key: 'geofence_radius_meters', value: '500.0', updatedAt: DateTime.now()),
            );
            _geoRadiusCtrl.text = geo.value;
          }
          if (_neglectDaysCtrl.text.isEmpty) {
            final neglect = settings.firstWhere(
              (s) => s.key == 'coverage_neglect_days',
              orElse: () => SystemSettingModel(key: 'coverage_neglect_days', value: '14.0', updatedAt: DateTime.now()),
            );
            _neglectDaysCtrl.text = neglect.value;
          }
          if (_maxPhotosCtrl.text.isEmpty) {
            final photos = settings.firstWhere(
              (s) => s.key == 'max_shelf_photos_per_visit',
              orElse: () => SystemSettingModel(key: 'max_shelf_photos_per_visit', value: '5.0', updatedAt: DateTime.now()),
            );
            _maxPhotosCtrl.text = photos.value;
          }
          if (_hardRejectCtrl.text.isEmpty) {
            final hard = settings.firstWhere(
              (s) => s.key == 'geofence_hard_reject_meters',
              orElse: () => SystemSettingModel(key: 'geofence_hard_reject_meters', value: '2000.0', updatedAt: DateTime.now()),
            );
            _hardRejectCtrl.text = hard.value;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(children: [
                        Icon(Icons.error_outline_rounded, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_errorMessage!, style: AppTextStyles.bodySm.copyWith(color: AppColors.error))),
                      ]),
                    ),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.my_location_rounded, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(AppStrings.visitGeofenceRadius, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface))),
                        ]),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _geoRadiusCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTextStyles.bodyMd,
                          decoration: InputDecoration(
                            labelText: AppStrings.radiusMeters,
                            helperText: 'Must be between 50 and 5000',
                            prefixIcon: Icon(Icons.straighten_rounded, color: AppColors.onSurfaceVariant),
                            filled: true, fillColor: AppColors.surfaceContainer,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            final num = double.tryParse(val);
                            if (num == null) return 'Must be a valid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.date_range_rounded, color: AppColors.warning, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(AppStrings.coverageNeglectWindow, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface))),
                        ]),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _neglectDaysCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTextStyles.bodyMd,
                          decoration: InputDecoration(
                            labelText: AppStrings.daysWithoutVisit,
                            helperText: 'Must be between 1 and 90',
                            prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.onSurfaceVariant),
                            filled: true, fillColor: AppColors.surfaceContainer,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            final num = double.tryParse(val);
                            if (num == null) return 'Must be a valid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.accent.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.camera_alt_rounded, color: AppColors.accent, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(AppStrings.maxShelfPhotosPer, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface))),
                        ]),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _maxPhotosCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTextStyles.bodyMd,
                          decoration: InputDecoration(
                            labelText: AppStrings.maxPhotos,
                            helperText: 'Between 1 and 20',
                            prefixIcon: Icon(Icons.photo_library_rounded, color: AppColors.onSurfaceVariant),
                            filled: true, fillColor: AppColors.surfaceContainer,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            final num = double.tryParse(val);
                            if (num == null) return 'Must be a valid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
                            child: Icon(Icons.block_rounded, color: AppColors.error, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(AppStrings.geofenceHardRejectRadius, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface))),
                        ]),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _hardRejectCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTextStyles.bodyMd,
                          decoration: InputDecoration(
                            labelText: AppStrings.hardRejectMeters,
                            helperText: 'Between 200 and 10000',
                            prefixIcon: Icon(Icons.gps_off_rounded, color: AppColors.onSurfaceVariant),
                            filled: true, fillColor: AppColors.surfaceContainer,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            final num = double.tryParse(val);
                            if (num == null) return 'Must be a valid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveSettings,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isSaving
                          ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.onPrimary))
                          : Text(AppStrings.saveSettings, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
