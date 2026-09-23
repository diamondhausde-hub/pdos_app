import 'package:drift/drift.dart' as drift;
import 'package:uuid/uuid.dart';
import '../models/appointment_model.dart';
import '../local_db/app_database.dart';
import '../services/notification_service.dart';
import '../services/api_service.dart';

class AppointmentRepository {
  final AppDatabase _localDb;
  final ApiService? _api;

  AppointmentRepository(this._localDb, [this._api]);

  /// Watch appointments for UI
  Stream<List<AppointmentModel>> watchAppointments({String? repId}) {
    var query = _localDb.select(_localDb.localAppointments)
      ..orderBy([
        (t) => drift.OrderingTerm(
          expression: t.apptDate,
          mode: drift.OrderingMode.asc,
        ),
      ]);
    if (repId != null) {
      query = query..where((t) => t.repId.equals(repId));
    }
    return query.watch().map(
      (rows) => rows.map((r) => AppointmentModel.fromLocal(r)).toList(),
    );
  }

  Future<void> createAppointmentForRep({
    required String repId,
    String? clientId,
    String? centerId,
    required DateTime dateTime,
    String? notes,
    String? suggestedProductId,
  }) async {
    final appt = AppointmentModel(
      id: const Uuid().v4(),
      repId: repId,
      clientId: clientId,
      centerId: centerId,
      apptDate: DateTime(dateTime.year, dateTime.month, dateTime.day),
      apptTime:
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
      notes: notes,
      suggestedProductId: suggestedProductId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await createAppointment(appt);
  }

  /// Create appointment locally (offline-first)
  Future<void> createAppointment(AppointmentModel appt) async {
    await _localDb
        .into(_localDb.localAppointments)
        .insert(
          appt.copyWith(synced: false).toLocalCompanion(),
          mode: drift.InsertMode.insertOrReplace,
        );

    // Schedule local notification
    await notificationService.scheduleAppointmentReminder(appt);
  }

  /// Schedule reminders for all pending appointments
  Future<void> scheduleAllPendingReminders() async {
    final all = await _localDb.select(_localDb.localAppointments).get();
    for (final local in all) {
      if (local.status == 'pending') {
        await notificationService.scheduleAppointmentReminder(
          AppointmentModel.fromLocal(local),
        );
      }
    }
  }

  /// Update appointment status locally
  Future<void> updateStatus(String id, AppointmentStatus status) async {
    await (_localDb.update(
      _localDb.localAppointments,
    )..where((t) => t.id.equals(id))).write(
      LocalAppointmentsCompanion(
        status: drift.Value(status.name),
        synced: const drift.Value(false),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );

    // If not pending, cancel any scheduled reminders for this appointment
    if (status != AppointmentStatus.pending) {
      await notificationService.cancelAppointmentReminder(id);
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _api?.dio.delete('/appointments/$id');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to delete online: $e');
    }
    await (_localDb.delete(
      _localDb.localAppointments,
    )..where((t) => t.id.equals(id))).go();
    await notificationService.cancelAppointmentReminder(id);
  }

  Future<void> updateAppointment(AppointmentModel appt) async {
    bool isSynced = appt.synced;
    if (isSynced) {
      try {
        final payload = {
          'visit_id': appt.visitId,
          'rep_id': appt.repId,
          'client_id': appt.clientId,
          'center_id': appt.centerId,
          'appt_date': appt.apptDate.toIso8601String(),
          'appt_time': appt.apptTime,
          'reminder_minutes_before': appt.reminderMinutesBefore,
          'notes': appt.notes,
          'status': appt.status.name,
        };
        await _api?.dio.put('/appointments/${appt.id}', data: payload);
      } catch (e) {
        // If it fails (offline), mark as unsynced so the sync orchestrator picks it up
        isSynced = false;
      }
    }

    final finalAppt = appt.copyWith(synced: isSynced);

    await _localDb
        .into(_localDb.localAppointments)
        .insert(
          finalAppt.toLocalCompanion(),
          mode: drift.InsertMode.insertOrReplace,
        );

    await notificationService.cancelAppointmentReminder(appt.id);
    if (appt.status == AppointmentStatus.pending) {
      await notificationService.scheduleAppointmentReminder(appt);
    }
  }
}
