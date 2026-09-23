import 'package:flutter/foundation.dart';

/// Visit status enum
enum VisitStatus {
  planned,
  arrived,
  inProgress,
  completed,
  flagged,
  rejected;

  static VisitStatus fromString(String value) {
    return VisitStatus.values.firstWhere(
      (e) => e.name == value || (e.name == 'inProgress' && value == 'in_progress'),
      orElse: () => VisitStatus.planned,
    );
  }

  String get displayName {
    switch (this) {
      case VisitStatus.planned:
        return 'Planned';
      case VisitStatus.arrived:
        return 'Arrived';
      case VisitStatus.inProgress:
        return 'In Progress';
      case VisitStatus.completed:
        return 'Completed';
      case VisitStatus.flagged:
        return 'Flagged';
      case VisitStatus.rejected:
        return 'Rejected';
    }
  }
}

/// Visit model — maps to public.visits
@immutable
class VisitModel {
  final String id;
  final String? referenceCode;
  final String repId;
  final String centerId;
  final String? brandId;
  final DateTime visitDate;
  final DateTime? arrivalTime;
  final DateTime? completionTime;
  final VisitStatus status;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? taskId;

  // Joined fields (optional, populated from queries)
  final String? centerName;
  final List<VisitItemModel>? items;
  final String? repRole;


  final List<SpecialRequestModel>? specialRequests;

  // Supervisor review fields
  final String? supervisorNote;

  // Retroactive & Save Location
  final String? retroactiveReason;
  final double? saveLocationLat;
  final double? saveLocationLng;
  final String? reviewNote;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  // Signature
  final String? signatureUrl;

  bool get isFlagged => status == VisitStatus.flagged;

  const VisitModel({
    required this.id,
    this.referenceCode,
    required this.repId,
    required this.centerId,
    this.brandId,
    required this.visitDate,
    this.arrivalTime,
    this.completionTime,
    this.status = VisitStatus.planned,
    this.notes,
    this.latitude,
    this.longitude,
    this.synced = false,
    required this.createdAt,
    required this.updatedAt,
    this.taskId,
    this.centerName,
    this.items,
    this.reviewNote,
    this.repRole,
    this.specialRequests,
    this.supervisorNote,
    this.retroactiveReason,
    this.saveLocationLat,
    this.saveLocationLng,
    this.reviewedBy,
    this.reviewedAt,
    this.signatureUrl,
  });

  /// Duration of the visit (if completed)
  Duration? get visitDuration {
    if (arrivalTime != null && completionTime != null) {
      return completionTime!.difference(arrivalTime!);
    }
    return null;
  }

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] as String,
      referenceCode: json['reference_code'] as String?,
      repId: json['rep_id'] as String,
      centerId: json['center_id'] as String? ?? '',
      brandId: json['brand_id'] as String?,
      visitDate: DateTime.parse(json['visit_date'] as String),
      arrivalTime: json['arrival_time'] != null ? DateTime.parse(json['arrival_time'] as String) : null,
      completionTime: json['completion_time'] != null ? DateTime.parse(json['completion_time'] as String) : null,
      status: VisitStatus.fromString(json['status'] as String? ?? 'planned'),
      notes: json['notes'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      synced: json['synced'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      taskId: json['task_id'] as String?,
      repRole: json['rep_role'] as String?,
      centerName: json['centers'] != null ? (json['centers'] as Map<String, dynamic>)['name'] as String? : null,
      reviewNote: json['review_note'] as String?,
      specialRequests: json['special_requests'] != null ? (json['special_requests'] as List).map((e) => SpecialRequestModel.fromJson(e as Map<String, dynamic>)).toList() : null,
      supervisorNote: json['supervisor_note'] as String?,
      retroactiveReason: json['retroactive_reason'] as String?,
      saveLocationLat: (json['save_location_lat'] as num?)?.toDouble(),
      saveLocationLng: (json['save_location_lng'] as num?)?.toDouble(),
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at'] as String) : null,
      signatureUrl: json['signature_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_code': referenceCode,
      'rep_id': repId,
      'center_id': centerId,
      'brand_id': brandId,
      'visit_date': visitDate.toIso8601String().split('T').first,
      'arrival_time': arrivalTime?.toIso8601String(),
      'completion_time': completionTime?.toIso8601String(),
      'status': status.name,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'synced': synced,
      'task_id': taskId,
      'review_note': reviewNote,
      'supervisor_note': supervisorNote,
      'retroactive_reason': retroactiveReason,
      'save_location_lat': saveLocationLat,
      'save_location_lng': saveLocationLng,
    };
  }
}

/// Visit item model — maps to public.visit_items
@immutable
class VisitItemModel {
  final String id;
  final String visitId;
  final String productId;
  final int qtySold;
  final int qtyFree;
  final DateTime createdAt;

  // Joined fields
  final String? productName;

  const VisitItemModel({
    required this.id,
    required this.visitId,
    required this.productId,
    this.qtySold = 0,
    this.qtyFree = 0,
    required this.createdAt,
    this.productName,
  });

  int get totalQty => qtySold + qtyFree;

  factory VisitItemModel.fromJson(Map<String, dynamic> json) {
    return VisitItemModel(
      id: json['id'] as String,
      visitId: json['visit_id'] as String,
      productId: json['product_id'] as String,
      qtySold: json['qty_sold'] as int? ?? 0,
      qtyFree: json['qty_free'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      productName: json['products'] != null ? (json['products'] as Map<String, dynamic>)['name'] as String? : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'visit_id': visitId,
      'product_id': productId,
      'qty_sold': qtySold,
      'qty_free': qtyFree,
    };
  }
}


@immutable
class SpecialRequestModel {
  final String id;
  final String? visitId;
  final String requestType;
  final String? description;
  final DateTime createdAt;

  const SpecialRequestModel({
    required this.id,
    this.visitId,
    required this.requestType,
    this.description,
    required this.createdAt,
  });

  factory SpecialRequestModel.fromJson(Map<String, dynamic> json) {
    return SpecialRequestModel(
      id: json['id'] as String,
      visitId: json['visit_id'] as String?,
      requestType: json['request_type'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'request_type': requestType,
      'description': description,
    };
  }
}
