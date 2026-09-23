import 'package:flutter_test/flutter_test.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:pdos_app/core/local_db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Cascade update and delete inside a transaction works correctly', () async {
    const tempCenterId = 'temp-uuid-123';
    const serverCenterId = 'server-uuid-456';
    const appointmentId = 'appt-1';

    // 1. Insert a temporary offline center
    await db.into(db.localCenters).insert(
      LocalCentersCompanion.insert(
        id: tempCenterId,
        name: 'Temp Pharmacy',
        region: const Value('Riyadh'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        synced: const Value(false),
      ),
    );

    // 2. Insert a local appointment that references the temporary center
    await db.into(db.localAppointments).insert(
      LocalAppointmentsCompanion.insert(
        id: appointmentId,
        centerId: const Value(tempCenterId), // References temp center
        repId: 'rep-1',
        apptDate: DateTime.now(),
        apptTime: '10:00',
        reminderMinutesBefore: const Value(30),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        synced: const Value(false),
      ),
    );

    // Verify initial state
    final apptBefore = await (db.select(db.localAppointments)..where((a) => a.id.equals(appointmentId))).getSingle();
    expect(apptBefore.centerId, tempCenterId);
    
    final centersBefore = await db.select(db.localCenters).get();
    expect(centersBefore.length, 1);
    expect(centersBefore.first.id, tempCenterId);

    // 3. Execute the transaction (simulating what ScheduleSyncService does)
    await db.transaction(() async {
      await db.updateAppointmentsCenterId(oldId: tempCenterId, newId: serverCenterId);
      await db.updateVisitsCenterId(oldId: tempCenterId, newId: serverCenterId);
      await db.deleteLocalCenter(tempCenterId);
    });

    // 4. Verify the cascade updates and deletion
    final apptAfter = await (db.select(db.localAppointments)..where((a) => a.id.equals(appointmentId))).getSingle();
    expect(apptAfter.centerId, serverCenterId, reason: 'Appointment center_id should be updated to the new server ID');

    final centersAfter = await db.select(db.localCenters).get();
    expect(centersAfter.isEmpty, true, reason: 'Temporary center should be deleted');
  });
}
