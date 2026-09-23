import 'package:flutter_test/flutter_test.dart';
import 'package:pdos_app/core/models/appointment_model.dart';

void main() {
  final createdAt = DateTime.utc(2026, 1, 1);

  test('serializes and restores visitId', () {
    final appointment = AppointmentModel(
      id: 'appointment-1',
      visitId: 'visit-1',
      repId: 'rep-1',
      apptDate: createdAt,
      apptTime: '10:00',
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    final restored = AppointmentModel.fromJson({
      ...appointment.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': createdAt.toIso8601String(),
    });

    expect(restored.visitId, 'visit-1');
    expect(restored.toJson()['visit_id'], 'visit-1');
  });

  test('keeps visitId when converting through local storage', () {
    final appointment = AppointmentModel(
      id: 'appointment-1',
      visitId: 'visit-1',
      repId: 'rep-1',
      apptDate: createdAt,
      apptTime: '10:00',
      createdAt: createdAt,
      updatedAt: createdAt,
    );

    final local = appointment.toLocalCompanion();
    expect(local.visitId.value, 'visit-1');
  });
}
