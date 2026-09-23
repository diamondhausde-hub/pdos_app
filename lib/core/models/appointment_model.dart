import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;
import '../local_db/app_database.dart';

enum AppointmentStatus { pending, done, missed }

@immutable
class AppointmentModel {
  final String id;
  final String? visitId;
  final String? referenceCode;
  final String repId;
  final String? clientId;
  final String? clientName;
  final String? centerId;
  final String? centerName;
  final DateTime apptDate;
  final String apptTime;
  final int reminderMinutesBefore;
  final String? notes;
  final String? supervisorNote;
  final String? suggestedProductId;
  final String? suggestedProductName;
  final AppointmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool synced;

  const AppointmentModel({
    required this.id,
    this.visitId,
    this.referenceCode,
    required this.repId,
    this.clientId,
    this.clientName,
    this.centerId,
    this.centerName,
    required this.apptDate,
    required this.apptTime,
    this.reminderMinutesBefore = 30,
    this.notes,
    this.supervisorNote,
    this.suggestedProductId,
    this.suggestedProductName,
    this.status = AppointmentStatus.pending,
    required this.createdAt,
    required this.updatedAt,
    this.synced = true,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      visitId: json['visit_id'] as String?,
      referenceCode: json['reference_code'] as String?,
      repId: json['rep_id'] as String,
      clientId: json['client_id'] as String?,
      clientName: json['client_name'] as String?,
      centerId: json['center_id'] as String?,
      centerName:
          json['center_name'] as String? ?? json['client_name'] as String?,
      apptDate: DateTime.parse(json['appt_date'] as String),
      apptTime: json['appt_time'] as String,
      reminderMinutesBefore: json['reminder_minutes_before'] as int? ?? 30,
      notes: json['notes'] as String?,
      supervisorNote: json['supervisor_note'] as String?,
      suggestedProductId: json['suggested_product_id'] as String?,
      suggestedProductName: json['suggested_product_name'] as String?,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AppointmentStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      synced: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'reference_code': referenceCode,
      'rep_id': repId,
      'client_id': clientId,
      'center_id': centerId,
      'appt_date': apptDate.toIso8601String(),
      'appt_time': apptTime,
      'reminder_minutes_before': reminderMinutesBefore,
      'notes': notes,
      'supervisor_note': supervisorNote,
      'suggested_product_id': suggestedProductId,
      'status': status.name,
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? visitId,
    String? referenceCode,
    String? repId,
    String? clientId,
    String? clientName,
    String? centerId,
    String? centerName,
    DateTime? apptDate,
    String? apptTime,
    int? reminderMinutesBefore,
    String? notes,
    String? supervisorNote,
    String? suggestedProductId,
    String? suggestedProductName,
    AppointmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? synced,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      referenceCode: referenceCode ?? this.referenceCode,
      repId: repId ?? this.repId,
      clientId: clientId ?? this.clientId,
      clientName: clientName ?? this.clientName,
      centerId: centerId ?? this.centerId,
      centerName: centerName ?? this.centerName,
      apptDate: apptDate ?? this.apptDate,
      apptTime: apptTime ?? this.apptTime,
      reminderMinutesBefore:
          reminderMinutesBefore ?? this.reminderMinutesBefore,
      notes: notes ?? this.notes,
      supervisorNote: supervisorNote ?? this.supervisorNote,
      suggestedProductId: suggestedProductId ?? this.suggestedProductId,
      suggestedProductName: suggestedProductName ?? this.suggestedProductName,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      synced: synced ?? this.synced,
    );
  }

  factory AppointmentModel.fromLocal(LocalAppointment local) {
    return AppointmentModel(
      id: local.id,
      visitId: local.visitId,
      referenceCode: local.referenceCode,
      repId: local.repId,
      clientId: local.clientId,
      centerId: local.centerId,
      centerName: local.centerName,
      apptDate: local.apptDate,
      apptTime: local.apptTime,
      reminderMinutesBefore: local.reminderMinutesBefore,
      notes: local.notes,
      supervisorNote: local.supervisorNote,
      suggestedProductId: local.suggestedProductId,
      suggestedProductName: local.suggestedProductName,
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name == local.status,
        orElse: () => AppointmentStatus.pending,
      ),
      createdAt: local.createdAt,
      updatedAt: local.updatedAt,
      synced: local.synced,
    );
  }

  LocalAppointmentsCompanion toLocalCompanion() {
    return LocalAppointmentsCompanion.insert(
      id: id,
      visitId: drift.Value(visitId),
      referenceCode: drift.Value(referenceCode),
      repId: repId,
      clientId: drift.Value(clientId),
      centerId: drift.Value(centerId),
      centerName: drift.Value(centerName),
      apptDate: apptDate,
      apptTime: apptTime,
      reminderMinutesBefore: drift.Value(reminderMinutesBefore),
      notes: drift.Value(notes),
      // supervisorNote not stored in local DB
      suggestedProductId: drift.Value(suggestedProductId),
      suggestedProductName: drift.Value(suggestedProductName),
      status: drift.Value(status.name),
      createdAt: createdAt,
      updatedAt: updatedAt,
      synced: drift.Value(synced),
    );
  }
}
