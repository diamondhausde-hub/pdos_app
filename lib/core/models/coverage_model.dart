import 'package:flutter/foundation.dart';

@immutable
class CoverageCenter {
  final String centerId;
  final String name;
  final double? lat;
  final double? lng;
  final DateTime? lastVisitDate;
  final String? assignedRepId;
  final String status;
  final bool hasSupervisorNote;
  final String? supervisorNote;

  const CoverageCenter({
    required this.centerId,
    required this.name,
    this.lat,
    this.lng,
    this.lastVisitDate,
    this.assignedRepId,
    required this.status,
    this.hasSupervisorNote = false,
    this.supervisorNote,
  });

  factory CoverageCenter.fromJson(Map<String, dynamic> json) {
    return CoverageCenter(
      centerId: json['center_id'] as String,
      name: json['name'] as String,
      lat: json['lat'] != null ? (json['lat'] as num).toDouble() : null,
      lng: json['lng'] != null ? (json['lng'] as num).toDouble() : null,
      lastVisitDate: json['last_visit_date'] != null ? DateTime.parse(json['last_visit_date']) : null,
      assignedRepId: json['assigned_rep_id'] as String?,
      status: json['status'] as String,
      hasSupervisorNote: json['has_supervisor_note'] as bool? ?? false,
      supervisorNote: json['supervisor_note'] as String?,
    );
  }
}
