import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:drift/drift.dart' as drift;

import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/center_model.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/models/expense_model.dart';
import '../../../core/models/visit_model.dart';
import '../widgets/batch_camera_capture.dart';

import 'visit_sales_form.dart';
import 'visit_stock_form.dart';
import '../../../shared/widgets/signature_capture_widget.dart';
import 'wizard/visit_wizard_expenses.dart';
import 'wizard/visit_wizard_special_requests.dart';
import 'wizard/visit_wizard_review.dart';
import 'visit_success_screen.dart';

class VisitWizardScreen extends ConsumerStatefulWidget {
  final String? appointmentId;
  final String centerId;
  final String? clientId;
  final String? taskId;
  const VisitWizardScreen({
    super.key,
    this.appointmentId,
    required this.centerId,
    this.clientId,
    this.taskId,
  });

  @override
  ConsumerState<VisitWizardScreen> createState() => _VisitWizardScreenState();
}

class _VisitWizardScreenState extends ConsumerState<VisitWizardScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  bool _isLoading = false;
  
  // State for Check-in / Retroactive
  bool _isCheckedIn = false;
  bool _isRetroactive = false;
  String? _retroactiveReason;
  double? _saveLocationLat;
  double? _saveLocationLng;

  final _notesController = TextEditingController();
  final List<Map<String, dynamic>> _salesItems = [];
  final List<Map<String, dynamic>> _stockChecks = [];
  final List<ExpenseModel> _expenses = [];
  final List<SpecialRequestModel> _specialRequests = [];
  final List<String> _localPhotos = [];
  
  String? _visitId;
  String? _signaturePath;
  late AnimationController _stepController;

  final List<_StepInfo> _steps = [
    _StepInfo(icon: Icons.login_rounded, label: AppStrings.start),
    _StepInfo(icon: Icons.inventory_2_rounded, label: AppStrings.stock),
    _StepInfo(icon: Icons.camera_alt_rounded, label: AppStrings.photos),
    _StepInfo(icon: Icons.shopping_cart_rounded, label: AppStrings.sales),
    _StepInfo(icon: Icons.receipt_long_rounded, label: AppStrings.extras),
    _StepInfo(icon: Icons.receipt_rounded, label: AppStrings.invoice),
    _StepInfo(icon: Icons.draw_rounded, label: AppStrings.sign),
  ];

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _stepController.forward();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  Future<void> _handleCheckIn(bool isRetroactive, {String? reason}) async {
    setState(() => _isLoading = true);
    try {
      Position? position;
      
      if (!isRetroactive) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            if (mounted) _showPermissionDeniedDialog();
            return;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          if (mounted) _showPermissionDeniedDialog();
          return;
        }

        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );

        final centers = ref.read(centersProvider).asData?.value ?? [];
        final center = centers.where((c) => c.id == widget.centerId).firstOrNull;
        if (center?.latitude != null && center?.longitude != null) {
          final distance = Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            center!.latitude!,
            center.longitude!,
          );
          if (distance > 20000000 && mounted) {
            _showDistanceRejectedDialog(distance);
            if (mounted) setState(() => _isLoading = false);
            return;
          } else if (distance > 500 && mounted) {
            final confirm = await _showDistanceWarningDialog(distance);
            if (confirm != true) {
              if (mounted) setState(() => _isLoading = false);
              return;
            }
          }
        }
      }

      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final repo = ref.read(visitRepositoryProvider);
      // Create visit
      final newVisitId = await repo.startVisit(
        repId: user.id,
        centerId: widget.centerId,
        clientId: widget.clientId,
        appointmentId: widget.appointmentId,
        taskId: widget.taskId,
        latitude: isRetroactive ? null : position?.latitude,
        longitude: isRetroactive ? null : position?.longitude,
      );

      if (mounted) {
        setState(() {
          _isCheckedIn = true;
          _isRetroactive = isRetroactive;
          _retroactiveReason = reason;
          _visitId = newVisitId;
          _isLoading = false;
          _currentStep = 1;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to check in: $e')));
      }
    }
  }

  void _showDistanceRejectedDialog(double distance) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(AppStrings.checkInRejected, style: AppTextStyles.headlineMd),
              const SizedBox(height: 8),
              Text(
                'You are ${distance.toStringAsFixed(0)}m away. Maximum allowed distance is 20,000km.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(AppStrings.ok),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDistanceWarningDialog(double distance) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, size: 48, color: AppColors.warning),
              const SizedBox(height: 16),
              Text(AppStrings.locationConfirmation, style: AppTextStyles.headlineMd),
              const SizedBox(height: 8),
              Text(
                'You are ${distance.toStringAsFixed(0)}m away. Continue check-in?',
                style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(AppStrings.cancel))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: Text(AppStrings.continueBtn))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_off_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(AppStrings.locationRequired, style: AppTextStyles.headlineMd),
              const SizedBox(height: 8),
              Text(AppStrings.weNeedYourLocation, style: AppTextStyles.bodyMd),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => context.pop(), child: Text(AppStrings.cancel))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(onPressed: () { context.pop(); Geolocator.openAppSettings(); }, child: Text(AppStrings.settings))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openBatchCamera() async {
    if (_visitId == null) return;

    final settingsService = ref.read(settingsServiceProvider);
    try {
      final allSettings = await settingsService.getSettings();
      final maxPhotosSetting = allSettings.where((s) => s.key == 'max_shelf_photos_per_visit').firstOrNull;
      final maxPhotos = maxPhotosSetting != null ? double.tryParse(maxPhotosSetting.value)?.toInt() ?? 10 : 10;

      final remaining = maxPhotos - _localPhotos.length;
      if (remaining <= 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Maximum $maxPhotos photos reached')));
        }
        return;
      }

      if (!mounted) return;
      final result = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(
          builder: (_) => BatchCameraCapture(maxPhotos: remaining),
        ),
      );

      if (result == null || result.isEmpty) return;

      final appDir = await getApplicationDocumentsDirectory();
      final visitsDir = Directory('${appDir.path}/visits');
      if (!await visitsDir.exists()) await visitsDir.create(recursive: true);

      final localDb = ref.read(appDatabaseProvider);

      for (final tempPath in result) {
        final fileName = '${_visitId}_${const Uuid().v4()}.jpg';
        final savedFile = await File(tempPath).copy('${visitsDir.path}/$fileName');
        await localDb.into(localDb.localVisitPhotos).insert(
          LocalVisitPhotosCompanion.insert(
            id: const Uuid().v4(),
            visitId: drift.Value(_visitId),
            photoPath: savedFile.path,
            createdAt: DateTime.now(),
          ),
        );
        if (mounted) setState(() => _localPhotos.add(savedFile.path));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _completeVisit() async {
    if (_visitId == null) return;
    
    // Save completion location
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
        );
        _saveLocationLat = position.latitude;
        _saveLocationLng = position.longitude;
      }
    } catch (_) {}

    setState(() => _isLoading = true);
    try {
      await Future(() async {
        final repo = ref.read(visitRepositoryProvider);
        final localDb = ref.read(appDatabaseProvider);
          
        await localDb.batch((batch) {
          for (final req in _specialRequests) {
            batch.insert(
              localDb.localSpecialRequests,
              LocalSpecialRequestsCompanion.insert(
                id: req.id,
                visitId: drift.Value(_visitId),
                requestType: req.requestType,
                description: req.description != null ? drift.Value(req.description) : const drift.Value.absent(),
                createdAt: req.createdAt,
              ),
            );
          }
          
          for (final exp in _expenses) {
            batch.insert(
              localDb.localExpenses,
              LocalExpensesCompanion.insert(
                id: exp.id,
                visitId: drift.Value(_visitId),
                repId: exp.repId,
                category: exp.category,
                amount: exp.amount,
                description: exp.description != null ? drift.Value(exp.description) : const drift.Value.absent(),
                receiptImagePath: exp.receiptImageUrl != null ? drift.Value(exp.receiptImageUrl) : const drift.Value.absent(),
                createdAt: exp.createdAt,
              ),
            );
          }
        });

        await repo.completeVisit(
          visitId: _visitId!,
          notes: _notesController.text,
          salesItems: _salesItems,
          stockChecks: _stockChecks,
          signaturePath: _signaturePath,
        );
        
        // Update local db with extra fields
        await (localDb.update(localDb.localVisits)..where((t) => t.id.equals(_visitId!)))
          .write(
            LocalVisitsCompanion(
              retroactiveReason: _retroactiveReason != null ? drift.Value(_retroactiveReason) : const drift.Value.absent(),
              saveLocationLat: _saveLocationLat != null ? drift.Value(_saveLocationLat) : const drift.Value.absent(),
              saveLocationLng: _saveLocationLng != null ? drift.Value(_saveLocationLng) : const drift.Value.absent(),
            )
          );
      }).timeout(const Duration(seconds: 10));

      if (mounted) {
        final user = ref.read(currentUserProvider);
        final repName = user?.fullName ?? 'Unknown Rep';
        
        String targetName = 'Unknown Target';
        if (widget.clientId != null) {
          final clients = ref.read(clientsStreamProvider).asData?.value ?? [];
          final client = clients.where((c) => c.id == widget.clientId).firstOrNull;
          targetName = client?.doctorName ?? client?.facilityName ?? 'Unknown Client';
        } else {
          final centers = ref.read(centersProvider).asData?.value ?? [];
          final center = centers.where((c) => c.id == widget.centerId).firstOrNull;
          targetName = center?.name ?? 'Unknown Center';
        }

        final products = ref.read(productsProvider).asData?.value ?? [];
        
        final mappedSales = _salesItems.map((s) {
          final p = products.where((prod) => prod.id == s['productId']).firstOrNull;
          return {
            ...s,
            'productName': p?.name ?? 'Unknown',
          };
        }).toList();

        final mappedStock = _stockChecks.map((s) {
          final p = products.where((prod) => prod.id == s['productId']).firstOrNull;
          return {
            ...s,
            'productName': p?.name ?? 'Unknown',
          };
        }).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VisitSuccessScreen(
              repName: repName,
              targetName: targetName,
              clientId: widget.clientId,
              visitDate: DateTime.now(),
              salesItems: mappedSales,
              stockChecks: mappedStock,
              photos: _localPhotos,
              expenses: _expenses,
              specialRequests: _specialRequests,
              notes: _notesController.text,
              signaturePath: _signaturePath,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final centers = ref.watch(centersProvider).asData?.value ?? [];
    final center = centers.where((c) => c.id == widget.centerId).firstOrNull;
    final clients = ref.watch(clientsStreamProvider).asData?.value ?? [];
    final client = widget.clientId != null ? clients.where((c) => c.id == widget.clientId).firstOrNull : null;

    final subtitle = client != null
        ? '${client.doctorName ?? client.facilityName ?? center?.name ?? 'Client'}${client.phoneNumber != null ? ' · ${client.phoneNumber}' : ''}'
        : center?.name ?? 'Loading...';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.activeVisit, style: AppTextStyles.headlineSm.copyWith(color: AppColors.onSurface)),
            Text(subtitle, style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
      body: Column(
        children: [
          _StepIndicator(currentStep: _currentStep, steps: _steps),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: _buildStepContent(_currentStep, center),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildStepContent(int step, CenterModel? center) {
    switch (step) {
      case 0:
        return _CheckInStep(
          isCheckedIn: _isCheckedIn,
          isLoading: _isLoading,
          onCheckInLive: () => _handleCheckIn(false),
          onCheckInRetro: (reason) => _handleCheckIn(true, reason: reason),
          center: center,
        );
      case 1:
        return VisitStockForm(
          initialChecks: _stockChecks,
          onChanged: (checks) => setState(() => _stockChecks..clear()..addAll(checks)),
        );
      case 2:
        return _PhotosWidget(
          photos: _localPhotos,
          onOpenCamera: _openBatchCamera,
        );
      case 3:
        return VisitSalesForm(
          initialItems: _salesItems,
          onChanged: (items) => setState(() => _salesItems..clear()..addAll(items)),
        );
      case 4:
        return SingleChildScrollView(
          child: Column(
            children: [
              VisitWizardExpenses(
                expenses: _expenses,
                onChanged: (expenses) => setState(() => _expenses..clear()..addAll(expenses)),
                visitId: _visitId ?? '',
                repId: ref.read(currentUserProvider)?.id ?? '',
              ),
              const Divider(height: 32),
              VisitWizardSpecialRequests(
                requests: _specialRequests,
                onChanged: (reqs) => setState(() => _specialRequests..clear()..addAll(reqs)),
                visitId: _visitId ?? '',
              ),
            ],
          ),
        );
      case 5:
        return VisitWizardReview(
          data: {
            'isRetroactive': _isRetroactive,
            'salesItems': _salesItems,
            'stockChecks': _stockChecks,
            'photos': _localPhotos,
            'expenses': _expenses,
            'specialRequests': _specialRequests,
            'signaturePath': _signaturePath,
          },
        );
      case 6:
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: AppStrings.visitNotes, border: OutlineInputBorder()),
                  maxLines: 3,
                ),
              ),
              SignatureCaptureWidget(
                onSign: (path) => setState(() => _signaturePath = path),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
        boxShadow: [BoxShadow(color: AppColors.onSurface.withValues(alpha: 0.04), blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _currentStep--),
                icon: Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(AppStrings.back, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: _currentStep < _steps.length - 1
                ? ElevatedButton.icon(
                    onPressed: (_currentStep == 0 && !_isCheckedIn) ? null : () => setState(() => _currentStep++),
                    icon: Icon(Icons.arrow_forward_rounded, size: 18),
                    label: Text(AppStrings.next, maxLines: 1, overflow: TextOverflow.ellipsis),
                  )
                : ElevatedButton.icon(
                    onPressed: _isLoading ? null : _completeVisit,
                    icon: _isLoading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary)) : Icon(Icons.check_circle_rounded, size: 20),
                    label: Text(_isLoading ? 'Saving...' : 'Complete Visit', maxLines: 1, overflow: TextOverflow.ellipsis),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                  ),
          ),
        ],
      ),
    );
  }
}

class _StepInfo {
  final IconData icon;
  final String label;
  const _StepInfo({required this.icon, required this.label});
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final List<_StepInfo> steps;
  const _StepIndicator({required this.currentStep, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i <= currentStep;
          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.primary : AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                    boxShadow: isActive ? AppColors.glowShadow : null,
                  ),
                  child: Icon(steps[i].icon, color: isActive ? Colors.white : AppColors.onSurfaceVariant, size: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  steps[i].label,
                  style: AppTextStyles.labelSm.copyWith(
                    color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _CheckInStep extends StatefulWidget {
  final bool isCheckedIn;
  final bool isLoading;
  final VoidCallback onCheckInLive;
  final void Function(String reason) onCheckInRetro;
  final CenterModel? center;
  
  const _CheckInStep({
    required this.isCheckedIn,
    required this.isLoading,
    required this.onCheckInLive,
    required this.onCheckInRetro,
    this.center,
  });

  @override
  State<_CheckInStep> createState() => _CheckInStepState();
}

class _CheckInStepState extends State<_CheckInStep> {
  String? _retroReason;
  
  @override
  Widget build(BuildContext context) {
    if (widget.isCheckedIn) {
      return Center(
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_rounded, size: 64, color: AppColors.success),
              const SizedBox(height: 16),
              Text(AppStrings.visitStarted, style: AppTextStyles.headlineMd),
              const SizedBox(height: 8),
              Text(widget.center?.name ?? '', style: AppTextStyles.bodyLg),
            ],
          ),
        ),
      );
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(AppStrings.liveEntry, style: AppTextStyles.headlineSm),
                  ],
                ),
                const SizedBox(height: 8),
                Text(AppStrings.checkInNowWith, style: AppTextStyles.bodySm),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.isLoading ? null : widget.onCheckInLive,
                    child: Text(AppStrings.enterNow),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(AppStrings.or),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history_rounded, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Text(AppStrings.retroactiveEntry, style: AppTextStyles.headlineSm),
                  ],
                ),
                const SizedBox(height: 8),
                Text(AppStrings.addAVisitThat, style: AppTextStyles.bodySm),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: AppStrings.reasonForRetroactiveEntry),
                  onChanged: (v) => setState(() => _retroReason = v),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: widget.isLoading || _retroReason == null || _retroReason!.isEmpty
                        ? null
                        : () => widget.onCheckInRetro(_retroReason!),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                    child: Text(AppStrings.finishedRetroactively),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotosWidget extends StatelessWidget {
  final List<String> photos;
  final VoidCallback onOpenCamera;
  
  const _PhotosWidget({
    required this.photos,
    required this.onOpenCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceContainer)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.shelfPhotos, style: AppTextStyles.headlineSm),
              Row(
                children: [
                  Text(
                    '${photos.length} photo${photos.length == 1 ? '' : 's'}',
                    style: AppTextStyles.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.camera_alt_rounded),
                    onPressed: onOpenCamera,
                    tooltip: AppStrings.openBatchCamera,
                  ),
                ],
              ),
            ],
          ),
          if (photos.isNotEmpty)
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photos.length,
                itemBuilder: (ctx, idx) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        Image.file(File(photos[idx]), width: 80, height: 80, fit: BoxFit.cover),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.onSurfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.check_circle, size: 16, color: Colors.greenAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (photos.isEmpty)
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: onOpenCamera,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.outlineVariant, width: 1.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt_rounded, size: 40, color: AppColors.onSurfaceVariant),
                        const SizedBox(height: 8),
                        Text(AppStrings.tapToOpenCamera, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
