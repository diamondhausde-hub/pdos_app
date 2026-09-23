// ignore_for_file: deprecated_member_use
import 'package:pdos_app/core/localization/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/theme/theme.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/brand_provider.dart';
import '../../../core/providers/data_providers.dart';
import '../../../core/models/client_model.dart';
import '../../../core/models/client_enums.dart';

class ClientFormScreen extends ConsumerStatefulWidget {
  final String? clientId;
  final String? initialType;

  const ClientFormScreen({super.key, this.clientId, this.initialType});

  @override
  ConsumerState<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends ConsumerState<ClientFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _loaded = false;

  late final TextEditingController _doctorNameCtrl;
  late final TextEditingController _facilityNameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _regionCtrl;
  late final TextEditingController _areaCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _nearbyLandmarkCtrl;
  
  late final TextEditingController _scientificInterestsCtrl;
  late final TextEditingController _productInterestsCtrl;
  late final TextEditingController _keyContactNameCtrl;
  late final TextEditingController _keyContactPositionCtrl;
  late final TextEditingController _keyContactPhoneCtrl;
  late final TextEditingController _departmentsCtrl;

  String _clientType = 'doctor';
  String? _specialty;
  String? _classTier;
  String? _pharmacyType;
  String? _institutionType;
  String? _relationshipType;
  DateTime? _birthDate;
  File? _photoFile;


  List<DropdownMenuItem<String>> _buildDropdownItems(List<String> items, String? currentValue) {
    final list = <String>[...items];
    if (currentValue != null && currentValue.isNotEmpty && !list.contains(currentValue)) {
      list.insert(0, currentValue);
    }
    return list.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList();
  }

  ClientModel? get _existingClient => _loaded ? _cachedClient : null;
  ClientModel? _cachedClient;

  @override
  void initState() {
    super.initState();
    _doctorNameCtrl = TextEditingController();
    _facilityNameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();
    _regionCtrl = TextEditingController();
    _areaCtrl = TextEditingController();
    _streetCtrl = TextEditingController();
    _nearbyLandmarkCtrl = TextEditingController();
    
    _scientificInterestsCtrl = TextEditingController();
    _productInterestsCtrl = TextEditingController();
    _keyContactNameCtrl = TextEditingController();
    _keyContactPositionCtrl = TextEditingController();
    _keyContactPhoneCtrl = TextEditingController();
    _departmentsCtrl = TextEditingController();

    if (widget.clientId != null) {
      _loadClient();
    } else {
      if (widget.initialType != null) {
        _clientType = widget.initialType!;
      }
      _loaded = true;
    }
  }

  void _loadClient() {
    final clients = ref.read(clientsStreamProvider).asData?.value ?? [];
    final c = clients.where((c) => c.id == widget.clientId).firstOrNull;
    if (c != null) {
      _cachedClient = c;
      _clientType = c.clientType;
        _doctorNameCtrl.text = c.doctorName ?? '';
      _facilityNameCtrl.text = c.facilityName ?? '';
      _phoneCtrl.text = c.phoneNumber ?? '';
      _descriptionCtrl.text = c.description ?? '';
      _regionCtrl.text = c.region ?? '';
      _areaCtrl.text = c.area ?? '';
      _streetCtrl.text = c.street ?? '';
      _nearbyLandmarkCtrl.text = c.nearbyLandmark ?? '';
      
      _scientificInterestsCtrl.text = c.scientificInterests ?? '';
      _productInterestsCtrl.text = c.productInterests ?? '';
      _keyContactNameCtrl.text = c.keyContactName ?? '';
      _keyContactPositionCtrl.text = c.keyContactPosition ?? '';
      _keyContactPhoneCtrl.text = c.keyContactPhone ?? '';
      _departmentsCtrl.text = c.departments ?? '';

      _specialty = c.specialty;
      _classTier = c.classTier;
      _pharmacyType = c.pharmacyType;
      _institutionType = c.institutionType;
      _relationshipType = c.relationshipType;
      _birthDate = c.birthDate;
    }
    _loaded = true;
  }

  @override
  void dispose() {
    _doctorNameCtrl.dispose();
    _facilityNameCtrl.dispose();
    _phoneCtrl.dispose();
    _descriptionCtrl.dispose();
    _regionCtrl.dispose();
    _areaCtrl.dispose();
    _streetCtrl.dispose();
    _nearbyLandmarkCtrl.dispose();
    
    _scientificInterestsCtrl.dispose();
    _productInterestsCtrl.dispose();
    _keyContactNameCtrl.dispose();
    _keyContactPositionCtrl.dispose();
    _keyContactPhoneCtrl.dispose();
    _departmentsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.selectPhotoSource),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text(AppStrings.camera),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text(AppStrings.gallery),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source != null) {
      final picked = await ImagePicker().pickImage(source: source, maxWidth: 512);
      if (picked != null) {
        setState(() => _photoFile = File(picked.path));
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) return;

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = GoRouter.of(context);

      final client = ClientModel(
        id: _existingClient?.id ?? const Uuid().v4(),
        clientType: _clientType,
        status: 'active', // Automatically mark as active on full save
        repId: user.id,
        brandId: ref.read(selectedBrandIdProvider),
        doctorName: _doctorNameCtrl.text.isNotEmpty ? _doctorNameCtrl.text : null,
        facilityName: _facilityNameCtrl.text.isNotEmpty ? _facilityNameCtrl.text : null,
        specialty: _specialty,
        birthDate: _birthDate,
        classTier: _classTier,
        pharmacyType: _pharmacyType,
        institutionType: _institutionType,
        relationshipType: _relationshipType,
        scientificInterests: _scientificInterestsCtrl.text.isNotEmpty ? _scientificInterestsCtrl.text : null,
        productInterests: _productInterestsCtrl.text.isNotEmpty ? _productInterestsCtrl.text : null,
        keyContactName: _keyContactNameCtrl.text.isNotEmpty ? _keyContactNameCtrl.text : null,
        keyContactPosition: _keyContactPositionCtrl.text.isNotEmpty ? _keyContactPositionCtrl.text : null,
        keyContactPhone: _keyContactPhoneCtrl.text.isNotEmpty ? _keyContactPhoneCtrl.text : null,
        departments: _departmentsCtrl.text.isNotEmpty ? _departmentsCtrl.text : null,
        description: _descriptionCtrl.text.isNotEmpty ? _descriptionCtrl.text : null,
        phoneNumber: _phoneCtrl.text.isNotEmpty ? _phoneCtrl.text : null,
        region: _regionCtrl.text.isNotEmpty ? _regionCtrl.text : null,
        area: _areaCtrl.text.isNotEmpty ? _areaCtrl.text : null,
        street: _streetCtrl.text.isNotEmpty ? _streetCtrl.text : null,
        nearbyLandmark: _nearbyLandmarkCtrl.text.isNotEmpty ? _nearbyLandmarkCtrl.text : null,
        photoUrl: _photoFile?.path,
        createdAt: _existingClient?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        synced: false,
      );

      await ref.read(clientRepositoryProvider).createClient(client);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(_existingClient != null ? 'Client updated' : 'Client created')),
        );
        navigator.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = _existingClient != null;
    
    final classificationOptions = CustomerClassification.values.map((e) => e.name).toList();
    final specialtyOptions = MedicalSpecialty.values.map((e) => e.name).toList();
    final pharmacyOptions = PharmacyType.values.map((e) => e.name).toList();
    final institutionOptions = InstitutionType.values.map((e) => e.name).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg(isDark),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Client' : 'New Client'),
        backgroundColor: AppColors.scaffoldBg(isDark),
        foregroundColor: AppColors.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            InkWell(
              onTap: _pickPhoto,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: _photoFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.file(_photoFile!, width: 56, height: 56, fit: BoxFit.cover),
                            )
                          : Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Text(AppStrings.tapToAddPhoto, style: AppTextStyles.bodyMd.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            if (_clientType == 'doctor') ...[
              TextFormField(
                controller: _doctorNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Doctor Name',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Specialty', prefixIcon: Icon(Icons.medical_services_rounded)),
                value: _specialty,
                items: _buildDropdownItems(specialtyOptions, _specialty),
                onChanged: (val) => setState(() => _specialty = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scientificInterestsCtrl,
                decoration: InputDecoration(labelText: 'Scientific Interests', prefixIcon: Icon(Icons.science_rounded)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _productInterestsCtrl,
                decoration: InputDecoration(labelText: 'Product Interests', prefixIcon: Icon(Icons.medication_rounded)),
              ),
            ],
            
            if (_clientType == 'pharmacy') ...[
              TextFormField(
                controller: _facilityNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Pharmacy Name',
                  prefixIcon: Icon(Icons.local_pharmacy_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Pharmacy Type', prefixIcon: Icon(Icons.category_rounded)),
                value: _pharmacyType,
                items: _buildDropdownItems(pharmacyOptions, _pharmacyType),
                onChanged: (val) => setState(() => _pharmacyType = val),
              ),
            ],
            
            if (_clientType == 'institution') ...[
              TextFormField(
                controller: _facilityNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Institution Name',
                  prefixIcon: Icon(Icons.business_rounded),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Institution Type', prefixIcon: Icon(Icons.category_rounded)),
                value: _institutionType,
                items: _buildDropdownItems(institutionOptions, _institutionType),
                onChanged: (val) => setState(() => _institutionType = val),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _departmentsCtrl,
                decoration: InputDecoration(labelText: 'Departments (Comma Separated)', prefixIcon: Icon(Icons.account_tree_rounded)),
              ),
              const SizedBox(height: 16),
              Text('Key Contact', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              TextFormField(
                controller: _keyContactNameCtrl,
                decoration: InputDecoration(labelText: 'Contact Name', prefixIcon: Icon(Icons.person_outline_rounded)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keyContactPositionCtrl,
                decoration: InputDecoration(labelText: 'Contact Position', prefixIcon: Icon(Icons.badge_rounded)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _keyContactPhoneCtrl,
                decoration: InputDecoration(labelText: 'Contact Phone', prefixIcon: Icon(Icons.phone_rounded)),
              ),
            ],

            const SizedBox(height: 24),
            Text('Common Information', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Classification (Class Tier)', prefixIcon: Icon(Icons.grade_rounded)),
              value: _classTier,
              items: _buildDropdownItems(classificationOptions, _classTier),
              onChanged: (val) => setState(() => _classTier = val),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _regionCtrl,
              decoration: InputDecoration(labelText: 'Region', prefixIcon: Icon(Icons.map_rounded)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _areaCtrl,
              decoration: InputDecoration(labelText: 'Area', prefixIcon: Icon(Icons.place_rounded)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneCtrl,
              decoration: InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_rounded)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionCtrl,
              decoration: InputDecoration(labelText: 'Description / Notes', prefixIcon: Icon(Icons.notes_rounded)),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(AppStrings.save),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
