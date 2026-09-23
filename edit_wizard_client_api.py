with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

original = '''      if (_mode == _VisitMode.newDoctor) {
        final client = ClientModel(
          id: clientId,
          repId: repId,
          doctorName: _reasonCtrl.text.isNotEmpty ? _reasonCtrl.text : 'New Doctor',
          specialty: _promoNotesCtrl.text.isNotEmpty ? _promoNotesCtrl.text : null,
          clientType: 'doctor',
          status: 'incomplete',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          latitude: _location?.latitude,
          longitude: _location?.longitude,
          gender: _gender,
          classTier: _classTier,
          treatmentQuality: _treatmentQuality,
          rating: _rating,
        );
        final db = ref.read(localDatabaseProvider);
        await db.into(db.localClients).insertOnConflictUpdate(client.toLocalCompanion());
        bool clientPushFailed = false;
        try {
          await ApiService.instance.dio.put('/clients/', data: client.toJson());
        } catch (_) {
          clientPushFailed = true;
        }
        if (!clientPushFailed) {
          await (db.update(db.localClients)..where((t) => t.id.equals(clientId)))
              .write(const LocalClientsCompanion(synced: drift.Value(true)));
        }
      }'''

replacement = '''      if (_mode == _VisitMode.newDoctor) {
        final client = ClientModel(
          id: clientId,
          repId: repId,
          doctorName: _reasonCtrl.text.isNotEmpty ? _reasonCtrl.text : 'New Doctor',
          specialty: _promoNotesCtrl.text.isNotEmpty ? _promoNotesCtrl.text : null,
          clientType: 'doctor',
          status: 'incomplete',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          latitude: _location?.latitude,
          longitude: _location?.longitude,
          gender: _gender,
          classTier: _classTier,
          treatmentQuality: _treatmentQuality,
          rating: _rating,
        );
        final db = ref.read(localDatabaseProvider);
        await db.into(db.localClients).insertOnConflictUpdate(client.toLocalCompanion());
        bool clientPushFailed = false;
        try {
          await ApiService.instance.dio.post('/clients', data: client.toJson());
        } catch (_) {
          clientPushFailed = true;
        }
        if (!clientPushFailed) {
          await (db.update(db.localClients)..where((t) => t.id.equals(clientId)))
              .write(const LocalClientsCompanion(synced: drift.Value(true)));
        }
      }'''

text = text.replace(original, replacement)

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
