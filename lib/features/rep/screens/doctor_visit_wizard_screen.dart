import 'dart:convert';
import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column, isNull, isNotNull;

import '../../../core/theme/theme.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/local_db/app_database.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/product_model.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/services/api_service.dart';
import '../../shared/widgets/schedule_appointment_sheet.dart';

class DoctorVisitWizardScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final String? clientId;
  const DoctorVisitWizardScreen({super.key, this.taskId, this.clientId});

  @override
  ConsumerState<DoctorVisitWizardScreen> createState() => _DoctorVisitWizardScreenState();
}

enum _VisitMode { existingDoctor, newDoctor }
enum _Action { startNow, schedule, alreadyCompleted }

class _DoctorVisitWizardScreenState extends ConsumerState<DoctorVisitWizardScreen> {
  int _step = 0;
  bool _saving = false;
  bool _saved = false;

  // Step 1: Doctor Selection
  _VisitMode _mode = _VisitMode.existingDoctor;
  ClientModel? _selectedClient;
  String? _newClientId;
  final _nameCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  DateTime? _birthDate;
  String? _gender;

  // Step 2: Action
  _Action? _action;

  // Step 3: Basic Info
  DateTime? _visitDate = DateTime.now();
  TimeOfDay? _visitTime = TimeOfDay.now();
  String? _visitType; // regular, first, followUp, newProduct
  double? _lat;
  double? _lng;
  bool _locating = false;
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  // Step 4: Visit Content
  final Set<String> _interestedProductIds = {};
  final Map<String, TextEditingController> _marketingMessages = {};
  final _reasonCtrl = TextEditingController();

  // Step 5: Samples & Promo
  final List<Map<String, dynamic>> _samples = []; // id, qty, batch
  bool _promoBrochures = false;
  bool _promoGifts = false;
  bool _promoFreeSamples = false;
  final _promoNotesCtrl = TextEditingController();

  // Step 6: Evaluation
  final _doctorReactionCtrl = TextEditingController();
  String? _interestLevel; // high, medium, low, none
  String? _classTier; // A, B, C, D
  int _stars = 0;
  String? _treatmentQuality; // good, average, bad

  // Step 7: Follow-up & Done
  int _successLevel = 0; // 1-5
  final _expectedPrescriptionsCtrl = TextEditingController();
  final _nextActionsCtrl = TextEditingController();
  String? _clinicStatus; // open, busy
  final _bestTimeCtrl = TextEditingController();
  DateTime? _nextVisitDate;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _specialtyCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    _reasonCtrl.dispose();
    _promoNotesCtrl.dispose();
    _doctorReactionCtrl.dispose();
    _expectedPrescriptionsCtrl.dispose();
    _nextActionsCtrl.dispose();
    _bestTimeCtrl.dispose();
    for (var ctrl in _marketingMessages.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  bool _hasAutoSelected = false;

  @override
  void initState() {
    super.initState();
  }

  void _deferred(VoidCallback fn) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(fn);
    });
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool get _canContinue {
    switch (_step) {
      case 0:
        if (_mode == _VisitMode.existingDoctor) return _selectedClient != null;
        return _nameCtrl.text.trim().isNotEmpty && _gender != null;
      case 1:
        return _action != null;
      case 2:
        if (_action == _Action.schedule) return true;
        bool locationOk = false;
        if (_action == _Action.startNow) locationOk = _lat != null && _lng != null;
        if (_action == _Action.alreadyCompleted) {
          locationOk = double.tryParse(_latCtrl.text.trim()) != null && double.tryParse(_lngCtrl.text.trim()) != null;
          if (_lat != null && _lng != null) locationOk = true;
        }
        return _visitDate != null && _visitTime != null && _visitType != null && locationOk;
      case 3:
        return _reasonCtrl.text.trim().isNotEmpty && _interestedProductIds.isNotEmpty;
      case 4:
        return true; // Optional samples
      case 5:
        return _classTier != null && _stars > 0 && _treatmentQuality != null && _interestLevel != null;
      case 6:
        return _successLevel > 0 && _clinicStatus != null;
      default:
        return false;
    }
  }

  Future<void> _saveDoctorQuickly() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    
    final db = ref.read(appDatabaseProvider);
    final now = DateTime.now();
    
    final clientId = _newClientId ?? const Uuid().v4();
    final client = ClientModel(
      id: clientId,
      repId: user.id,
      status: 'incomplete', // Flag as quick add
      doctorName: _nameCtrl.text.trim(),
      specialty: _specialtyCtrl.text.trim().isEmpty ? null : _specialtyCtrl.text.trim(),
      birthDate: _birthDate,
      gender: _gender,
      createdAt: now,
      updatedAt: now,
      synced: false,
    );
    
    await db.into(db.localClients).insertOnConflictUpdate(client.toLocalCompanion());
    
    setState(() {
      _selectedClient = client;
      _newClientId = clientId; // keep the id if we save full visit later
    });
  }

  void _next() async {
    if (_step == 0 && _mode == _VisitMode.existingDoctor && _selectedClient != null) {
      final c = _selectedClient!;
      if (_nameCtrl.text.trim().isEmpty) {
        _nameCtrl.text = c.doctorName ?? '';
        _specialtyCtrl.text = c.specialty ?? '';
        _birthDate = c.birthDate;
        _gender = c.gender;
      }
    }
    
    if (_step == 1 && _action == _Action.schedule) {
      if (_mode == _VisitMode.newDoctor && _selectedClient == null) {
        await _saveDoctorQuickly();
      }
      if (mounted) {
        final result = await showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id, initialClientObj: _selectedClient);
        if (result == true && mounted) {
          context.go('/rep/my-day'); // Navigate away or pop if they scheduled successfully
        }
      }
      return;
    }

    setState(() => _step++);
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _pullGps() async {
    setState(() => _locating = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        _toast('Location permission denied');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        if (_action == _Action.alreadyCompleted) {
          _latCtrl.text = _lat.toString();
          _lngCtrl.text = _lng.toString();
        }
      });
    } catch (_) {
      _toast('Could not get location — try again');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('Not signed in');
      final db = ref.read(appDatabaseProvider);
      final now = DateTime.now();

      String clientId;
      ClientModel client;
      
      final clientJsonData = {
        'treatmentQuality': _treatmentQuality,
        'rating': _stars,
        'classTier': _classTier,
      };

      if (_mode == _VisitMode.newDoctor) {
        clientId = _newClientId ?? const Uuid().v4();
        client = ClientModel(
          id: clientId,
          repId: user.id,
          status: 'incomplete', // Flag as quick add
          doctorName: _nameCtrl.text.trim(),
          specialty: _specialtyCtrl.text.trim().isEmpty ? null : _specialtyCtrl.text.trim(),
          birthDate: _birthDate,
          gender: _gender,
          classTier: _classTier,
          rating: _stars,
          treatmentQuality: _treatmentQuality,
          description: jsonEncode(clientJsonData), // Store extras
          latitude: _lat,
          longitude: _lng,
          createdAt: now,
          updatedAt: now,
          synced: false,
        );
      } else {
        final existing = _selectedClient!;
        clientId = existing.id;
        client = existing.copyWith(
          doctorName: _nameCtrl.text.trim(),
          specialty: _specialtyCtrl.text.trim().isEmpty ? null : _specialtyCtrl.text.trim(),
          birthDate: _birthDate,
          gender: _gender,
          classTier: _classTier,
          rating: _stars,
          treatmentQuality: _treatmentQuality,
          latitude: _lat ?? existing.latitude,
          longitude: _lng ?? existing.longitude,
          updatedAt: now,
          synced: false,
        );
      }

      await db.into(db.localClients).insertOnConflictUpdate(client.toLocalCompanion());
      bool clientPushFailed = false;
      try {
        await ApiService.instance.dio.put('/clients/$clientId', data: client.toJson());
      } catch (_) {
        clientPushFailed = true;
      }

      final visitId = const Uuid().v4();
      final retro = _action == _Action.alreadyCompleted;
      
      DateTime finalVisitDate = _visitDate!;
      if (_visitTime != null) {
        finalVisitDate = DateTime(
          _visitDate!.year, _visitDate!.month, _visitDate!.day,
          _visitTime!.hour, _visitTime!.minute
        );
      }

      // Serialize rich data into notes
      final marketingDict = {};
      for (var entry in _marketingMessages.entries) {
        if (entry.value.text.trim().isNotEmpty) {
          marketingDict[entry.key] = entry.value.text.trim();
        }
      }

      final richNotesData = {
        'marketing_messages': marketingDict,
        'samples': _samples,
        'promo_materials': {
          'brochures': _promoBrochures,
          'gifts': _promoGifts,
          'free_samples': _promoFreeSamples,
          'notes': _promoNotesCtrl.text.trim()
        },
        'evaluation': {
          'doctor_reaction': _doctorReactionCtrl.text.trim(),
          'interest_level': _interestLevel,
        },
        'follow_up': {
          'success_level': _successLevel,
          'expected_prescriptions': _expectedPrescriptionsCtrl.text.trim(),
          'next_actions': _nextActionsCtrl.text.trim(),
          'clinic_status': _clinicStatus,
          'best_time': _bestTimeCtrl.text.trim(),
          'next_visit_date': _nextVisitDate?.toIso8601String()
        }
      };

      final combinedNotes = "${_reasonCtrl.text.trim()}\n\n---DATA---\n${jsonEncode(richNotesData)}";

      await db.into(db.localVisits).insert(LocalVisitsCompanion.insert(
        id: visitId,
        repId: user.id,
        centerId: '', // Doctor visits don't need a center
        clientId: Value(clientId),
        visitDate: finalVisitDate,
        arrivalTime: Value(retro ? null : finalVisitDate),
        completionTime: Value(now),
        status: 'completed',
        notes: Value(combinedNotes),
        latitude: Value(_lat ?? double.tryParse(_latCtrl.text)),
        longitude: Value(_lng ?? double.tryParse(_lngCtrl.text)),
        retroactiveReason: Value(retro ? 'Completed earlier' : null),
        saveLocationLat: Value(retro ? _lat : null),
        saveLocationLng: Value(retro ? _lng : null),
        synced: const Value(false),
        createdAt: now,
        updatedAt: now,
        visitType: const Value('doctor'),
        taskId: Value(widget.taskId),
        visitReason: Value(_visitType ?? 'regular'), // Store visit type here
        interestedProductIds: Value(_interestedProductIds.join(',')),
      ));

      ref.read(syncServiceProvider).syncNow();

      if (!mounted) return;
      setState(() {
        _saved = true;
        _saving = false;
      });
      
      if (clientPushFailed && mounted) {
        _toast('Visit saved locally. Will sync when online.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _toast('Failed to save visit: $e');
    }
  }

  // ────────────────────────── UI ──────────────────────────

  static const _stepTitles = [
    AppStrings.doctorSelection,
    AppStrings.visitAction,
    AppStrings.basicInfo,
    AppStrings.visitContent,
    AppStrings.promotionalMaterials,
    AppStrings.evaluationAndFeedback,
    AppStrings.followUpAndDone,
  ];

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsStreamProvider);

    if (widget.clientId != null && !_hasAutoSelected && clientsAsync.hasValue) {
      final match = clientsAsync.value!.where((c) => c.id == widget.clientId).firstOrNull;
      if (match != null) {
        _hasAutoSelected = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _selectedClient = match;
              _nameCtrl.text = match.doctorName ?? '';
              _specialtyCtrl.text = match.specialty ?? '';
              _birthDate = match.birthDate;
              _gender = match.gender;
            });
          }
        });
      }
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: _saved ? null : AppBar(
        title: Text(_stepTitles[_step.clamp(0, _stepTitles.length - 1)]),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
        leading: _step == 0
            ? IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => context.pop())
            : IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: _back),
      ),
      body: _saved
          ? _buildDone(isDark)
          : Column(
              children: [
                _buildProgress(isDark),
                Expanded(child: _buildStep(isDark)),
                _buildNavButtons(isDark),
              ],
            ),
    );
  }

  Widget _buildProgress(bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: List.generate(7, (i) {
          final done = i < _step;
          final active = i == _step;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: done || active ? AppColors.primary : AppColors.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep(bool isDark) {
    switch (_step) {
      case 0: return _pickDoctor(isDark);
      case 1: return _actionStep(isDark);
      case 2: return _basicInfoStep(isDark);
      case 3: return _contentStep(isDark);
      case 4: return _samplesStep(isDark);
      case 5: return _evaluationStep(isDark);
      case 6: return _followUpStep(isDark);
      default: return const SizedBox.shrink();
    }
  }

  Widget _field({required TextEditingController controller, required String label, IconData? icon, TextInputType keyboard = TextInputType.text, int maxLines = 1, String? hint, Widget? suffix}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: TextStyle(color: AppColors.onSurface),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 20) : null,
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.cardBg(isDark),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 16),
      child: Text(text, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w700, color: AppColors.onSurfaceVariant)),
    );
  }

  // --- Step 0: Doctor Selection ---
  Widget _pickDoctor(bool isDark) {
    final clientsAsync = ref.watch(clientsStreamProvider);
    final doctors = (clientsAsync.asData?.value ?? []).where((c) => (c.doctorName ?? '').trim().isNotEmpty).toList()..sort((a, b) => (a.doctorName ?? '').compareTo(b.doctorName ?? ''));
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SegmentedButton<_VisitMode>(
          segments: const [
            ButtonSegment(value: _VisitMode.existingDoctor, label: Text(AppStrings.existing), icon: Icon(Icons.person_search_rounded)),
            ButtonSegment(value: _VisitMode.newDoctor, label: Text(AppStrings.addNew), icon: Icon(Icons.person_add_rounded)),
          ],
          selected: {_mode},
          onSelectionChanged: (s) => _deferred(() => _mode = s.first),
        ),
        const SizedBox(height: 16),
        if (_mode == _VisitMode.newDoctor)
          _newDoctorForm()
        else if (clientsAsync.isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
        else if (doctors.isEmpty)
          GlassCard(child: Padding(padding: const EdgeInsets.all(20), child: Text(AppStrings.noDoctorsYet)))
        else
          ...doctors.map((d) {
            final selected = _selectedClient?.id == d.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GlassCard(
                onTap: () => _deferred(() => _selectedClient = d),
                variant: selected ? GlassVariant.primary : GlassVariant.normal,
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded, color: selected ? AppColors.primary : AppColors.onSurfaceVariant),
                  title: Text(d.doctorName!, style: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w700)),
                  subtitle: Text([d.specialty, d.classTier != null ? 'Class ${d.classTier}' : null].whereType<String>().join(' • '), style: AppTextStyles.bodySm),
                ),
              ),
            );
          }),
      ],
    );
  }

  Widget _newDoctorForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline_rounded, color: AppColors.warning, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'إضافة سريعة: سيتم حفظ المعلومات الأساسية فقط. يرجى إكمال باقي الملف (الموقع، التواصل، الخ) لاحقاً.',
                  style: AppTextStyles.bodySm.copyWith(color: AppColors.warning),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _sectionLabel('Doctor Information'),
        _field(controller: _nameCtrl, label: AppStrings.doctorName, icon: Icons.badge_rounded),
        const SizedBox(height: 12),
        _field(controller: _specialtyCtrl, label: AppStrings.specialty, icon: Icons.medical_information_rounded),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.cake_rounded, color: AppColors.onSurfaceVariant),
            title: Text(AppStrings.dateOfBirth, style: AppTextStyles.bodyMd),
            subtitle: Text(_birthDate == null ? 'Not set' : DateFormat('yyyy-MM-dd').format(_birthDate!), style: AppTextStyles.bodySm),
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: _birthDate ?? DateTime(1980), firstDate: DateTime(1930), lastDate: DateTime.now());
              if (picked != null) setState(() => _birthDate = picked);
            },
          ),
        ),
        _sectionLabel('Gender *'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'male', label: Text(AppStrings.male)),
            ButtonSegment(value: 'female', label: Text(AppStrings.female)),
          ],
          selected: {_gender ?? ''},
          onSelectionChanged: (s) => _deferred(() => _gender = s.first),
          emptySelectionAllowed: true,
        ),
      ],
    );
  }

  // --- Step 1: Action ---
  Widget _actionStep(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _actionCard(_Action.startNow, AppStrings.startVisitNow, Icons.play_arrow_rounded, AppColors.success),
        const SizedBox(height: 16),
        _actionCard(_Action.alreadyCompleted, AppStrings.alreadyCompleted, Icons.history_rounded, AppColors.info),
        const SizedBox(height: 16),
        _actionCard(_Action.schedule, AppStrings.addToSchedule, Icons.calendar_month_rounded, AppColors.warning),
      ],
    );
  }

  Widget _actionCard(_Action action, String title, IconData icon, Color color) {
    final sel = _action == action;
    return GlassCard(
      onTap: () => _deferred(() => _action = action),
      variant: sel ? GlassVariant.primary : GlassVariant.normal,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.headlineSm)),
            if (sel) Icon(Icons.check_circle_rounded, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  // --- Step 2: Basic Info ---
  Widget _basicInfoStep(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionLabel(AppStrings.visitType),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: [
            _typeChip('regular', AppStrings.regularVisit),
            _typeChip('first', AppStrings.firstVisit),
            _typeChip('follow_up', AppStrings.followUpVisit),
            _typeChip('new_product', AppStrings.newProductPresentation),
          ],
        ),
        
        _sectionLabel('Date & Time'),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                onTap: () async {
                  final d = await showDatePicker(context: context, initialDate: _visitDate ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (d != null) setState(() => _visitDate = d);
                },
                child: Row(children: [Icon(Icons.calendar_today_rounded, size: 18), const SizedBox(width: 8), Text(_visitDate != null ? DateFormat('MMM dd, yyyy').format(_visitDate!) : 'Select Date')]),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GlassCard(
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: _visitTime ?? TimeOfDay.now());
                  if (t != null) setState(() => _visitTime = t);
                },
                child: Row(children: [Icon(Icons.access_time_rounded, size: 18), const SizedBox(width: 8), Text(_visitTime != null ? _visitTime!.format(context) : 'Select Time')]),
              ),
            ),
          ],
        ),

        _sectionLabel(AppStrings.location),
        if (_action == _Action.startNow)
          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.my_location_rounded, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(child: Text(_lat == null ? 'GPS Required' : 'Location Captured: ${_lat!.toStringAsFixed(4)}, ${_lng!.toStringAsFixed(4)}')),
                if (_lat == null) TextButton(onPressed: _pullGps, child: _locating ? const CircularProgressIndicator() : const Text('Pull GPS')),
              ],
            ),
          )
        else ...[
          Row(children: [
            Expanded(child: _field(controller: _latCtrl, label: 'Latitude', keyboard: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: _field(controller: _lngCtrl, label: 'Longitude', keyboard: TextInputType.number)),
          ]),
          Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: _pullGps, icon: const Icon(Icons.my_location_rounded), label: const Text('Use Current GPS'))),
        ],
      ],
    );
  }

  Widget _typeChip(String id, String label) {
    final sel = _visitType == id;
    return ChoiceChip(
      label: Text(label),
      selected: sel,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      onSelected: (v) => setState(() => _visitType = id),
    );
  }

  // --- Step 3: Visit Content ---
  Widget _contentStep(bool isDark) {
    final productsAsync = ref.watch(productsProvider);
    final products = productsAsync.asData?.value ?? [];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionLabel(AppStrings.whyAreYouVisiting),
        _field(controller: _reasonCtrl, label: 'Main Discussion Points', maxLines: 4, hint: 'What happened during the visit?'),

        _sectionLabel(AppStrings.productsDiscussed),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: products.map((p) {
            final sel = _interestedProductIds.contains(p.id);
            return FilterChip(
              selected: sel,
              label: Text(p.name),
              onSelected: (v) {
                setState(() {
                  if (v) {
                    _interestedProductIds.add(p.id);
                    _marketingMessages[p.id] = TextEditingController();
                  } else {
                    _interestedProductIds.remove(p.id);
                    _marketingMessages.remove(p.id)?.dispose();
                  }
                });
              },
            );
          }).toList(),
        ),

        if (_interestedProductIds.isNotEmpty) ...[
          const SizedBox(height: 16),
          ..._interestedProductIds.map((id) {
            final p = products.firstWhere((p) => p.id == id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _field(controller: _marketingMessages[id]!, label: '${AppStrings.marketingMessage} - ${p.name}', hint: 'Feedback or message delivered for ${p.name}'),
            );
          }),
        ],
      ],
    );
  }

  // --- Step 4: Samples & Promo ---
  Widget _samplesStep(bool isDark) {
    final productsAsync = ref.watch(productsProvider);
    final products = productsAsync.asData?.value ?? [];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionLabel(AppStrings.medicalSamples),
        if (_samples.isEmpty)
          Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(AppStrings.noSamplesAdded, style: AppTextStyles.bodySm))
        else
          ..._samples.asMap().entries.map((entry) {
            final idx = entry.key;
            final s = entry.value;
            final p = products.firstWhere((prod) => prod.id == s['product_id']);
            return GlassCard(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text('${p.name} (Qty: ${s['qty']})')),
                  IconButton(icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error), onPressed: () => setState(() => _samples.removeAt(idx))),
                ],
              ),
            );
          }),
        OutlinedButton.icon(
          onPressed: () => _showAddSampleDialog(products),
          icon: const Icon(Icons.add_rounded),
          label: const Text(AppStrings.addSample),
        ),

        const SizedBox(height: 16),
        _sectionLabel(AppStrings.promotionalMaterials),
        CheckboxListTile(title: const Text(AppStrings.brochures), value: _promoBrochures, onChanged: (v) => setState(() => _promoBrochures = v!)),
        CheckboxListTile(title: const Text(AppStrings.gifts), value: _promoGifts, onChanged: (v) => setState(() => _promoGifts = v!)),
        CheckboxListTile(title: const Text(AppStrings.freeSamples), value: _promoFreeSamples, onChanged: (v) => setState(() => _promoFreeSamples = v!)),
        const SizedBox(height: 8),
        _field(controller: _promoNotesCtrl, label: 'Promo Notes', maxLines: 2),
      ],
    );
  }

  void _showAddSampleDialog(List<ProductModel> products) {
    String? selectedProductId;
    final qtyCtrl = TextEditingController();
    final batchCtrl = TextEditingController();
    
    showDialog(context: context, builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) {
      return AlertDialog(
        title: const Text('Add Sample'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              initialValue: selectedProductId,
              items: products.map((p) => DropdownMenuItem(value: p.id, child: Text(p.name))).toList(),
              onChanged: (v) => setDialogState(() => selectedProductId = v),
              decoration: const InputDecoration(labelText: 'Product'),
            ),
            const SizedBox(height: 12),
            TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: batchCtrl, decoration: const InputDecoration(labelText: 'Batch Number (Optional)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () {
            if (selectedProductId != null && qtyCtrl.text.isNotEmpty) {
              setState(() {
                _samples.add({
                  'product_id': selectedProductId,
                  'qty': int.tryParse(qtyCtrl.text) ?? 1,
                  'batch': batchCtrl.text.trim(),
                });
              });
              Navigator.pop(ctx);
            }
          }, child: const Text('Add')),
        ],
      );
    }));
  }

  // --- Step 5: Evaluation ---
  Widget _evaluationStep(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionLabel(AppStrings.doctorReaction),
        _field(controller: _doctorReactionCtrl, label: 'Reaction Notes', maxLines: 3),

        _sectionLabel(AppStrings.interestLevel),
        Wrap(
          spacing: 8,
          children: ['High', 'Medium', 'Low', 'None'].map((lvl) {
            return ChoiceChip(
              label: Text(lvl),
              selected: _interestLevel == lvl,
              onSelected: (v) => setState(() => _interestLevel = lvl),
            );
          }).toList(),
        ),

        _sectionLabel('Doctor Class Tier *'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['A', 'B', 'C', 'D'].map((c) {
            return ChoiceChip(
              label: Text(c, style: AppTextStyles.headlineMd.copyWith(fontWeight: FontWeight.w800)),
              selected: _classTier == c,
              onSelected: (_) => setState(() => _classTier = c),
            );
          }).toList(),
        ),

        _sectionLabel('General Rating *'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            return IconButton(
              iconSize: 38,
              icon: Icon(i < _stars ? Icons.star_rounded : Icons.star_border_rounded, color: i < _stars ? Colors.amber : AppColors.onSurfaceVariant),
              onPressed: () => setState(() => _stars = i + 1),
            );
          }),
        ),

        _sectionLabel('Treatment Quality *'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'good', label: Text('Good')),
            ButtonSegment(value: 'average', label: Text('Average')),
            ButtonSegment(value: 'bad', label: Text('Bad')),
          ],
          selected: {_treatmentQuality ?? ''},
          onSelectionChanged: (s) => setState(() => _treatmentQuality = s.first),
          emptySelectionAllowed: true,
        ),
      ],
    );
  }

  // --- Step 6: Follow-up ---
  Widget _followUpStep(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _sectionLabel(AppStrings.visitSuccessLevel),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            return IconButton(
              iconSize: 38,
              icon: Icon(i < _successLevel ? Icons.sentiment_satisfied_rounded : Icons.sentiment_neutral_rounded, color: i < _successLevel ? AppColors.success : AppColors.onSurfaceVariant),
              onPressed: () => setState(() => _successLevel = i + 1),
            );
          }),
        ),
        
        _sectionLabel(AppStrings.expectedPrescriptions),
        _field(controller: _expectedPrescriptionsCtrl, label: 'Expected Prescriptions/Commitment', maxLines: 2),

        _sectionLabel(AppStrings.nextActions),
        _field(controller: _nextActionsCtrl, label: 'Follow-up Required', maxLines: 2),

        _sectionLabel(AppStrings.clinicStatus),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'open', label: Text('Open/Normal')),
            ButtonSegment(value: 'busy', label: Text('Very Busy')),
          ],
          selected: {_clinicStatus ?? ''},
          onSelectionChanged: (s) => setState(() => _clinicStatus = s.first),
          emptySelectionAllowed: true,
        ),

        const SizedBox(height: 12),
        _field(controller: _bestTimeCtrl, label: AppStrings.bestTimeForNextVisit, hint: 'e.g. Morning, after 2 PM'),
        
        const SizedBox(height: 12),
        GlassCard(
          onTap: () async {
            final d = await showDatePicker(context: context, initialDate: DateTime.now().add(const Duration(days: 7)), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
            if (d != null) setState(() => _nextVisitDate = d);
          },
          child: Row(children: [Icon(Icons.event_rounded, size: 18), const SizedBox(width: 8), Text(_nextVisitDate != null ? DateFormat('MMM dd, yyyy').format(_nextVisitDate!) : 'Select Next Visit Date')]),
        ),
      ],
    );
  }

  // --- Common UI Elements ---
  Widget _buildNavButtons(bool isDark) {
    final last = _step == 6;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          children: [
            if (_step > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : _back,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text(AppStrings.back),
                ),
              ),
            if (_step > 0) const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton.icon(
                onPressed: _canContinue && !_saving ? (last ? _save : _next) : null,
                icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : Icon(last ? Icons.check_rounded : Icons.arrow_forward_rounded),
                label: Text(last ? 'Save Visit' : 'Next'),
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDone(bool isDark) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(width: 96, height: 96, decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.12), shape: BoxShape.circle), child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 56)),
            const SizedBox(height: 24),
            Text(AppStrings.doctorVisitSaved, textAlign: TextAlign.center, style: AppTextStyles.headlineLg),
            const SizedBox(height: 8),
            Text(AppStrings.theReportWasSaved, textAlign: TextAlign.center, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: 36),
            FilledButton.tonalIcon(
              onPressed: _saving ? null : () => showScheduleAppointmentSheet(context, ref),
              icon: const Icon(Icons.event_available_rounded),
              label: const Text(AppStrings.scheduleNewAppointment),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14)),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.go('/rep/my-day'),
              icon: const Icon(Icons.flag_rounded),
              label: const Text(AppStrings.finish),
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }
}
