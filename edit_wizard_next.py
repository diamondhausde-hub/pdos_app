import re

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

replacement = '''  Future<void> _saveDoctorQuickly() async {
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
        showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id);
      }
      return;
    }

    setState(() => _step++);
  }'''

original_search = '''  void _next() {
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
      showScheduleAppointmentSheet(context, ref);
      return;
    }

    setState(() => _step++);
  }'''

if original_search in text:
    text = text.replace(original_search, replacement)
    with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
        f.write(text)
    print("Done")
else:
    print("Search string not found")
