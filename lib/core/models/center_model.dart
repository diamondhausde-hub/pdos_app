import 'package:flutter/foundation.dart';

/// Pharmacy / distribution center model — maps to public.centers
@immutable
class CenterModel {
  final String id;
  final String name;
  final String? region;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? assignedRepId;
  final String? createdBy;
  final bool isActive;
  final String status;
  final String? rejectionReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? brandId;

  const CenterModel({
    required this.id,
    required this.name,
    this.region,
    this.latitude,
    this.longitude,
    this.address,
    this.assignedRepId,
    this.createdBy,
    this.isActive = true,
    this.status = 'active',
    this.rejectionReason,
    required this.createdAt,
    required this.updatedAt,
    this.brandId,
  });

  factory CenterModel.fromJson(Map<String, dynamic> json) {
    return CenterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      region: json['region'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      address: json['address'] as String?,
      assignedRepId: json['assigned_rep_id'] as String?,
      createdBy: json['created_by'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      status: json['status'] as String? ?? 'active',
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      brandId: json['brand_id'] as String?,
    );
  }

  CenterModel copyWith({String? status, String? rejectionReason}) {
    return CenterModel(
      id: id,
      name: name,
      region: region,
      latitude: latitude,
      longitude: longitude,
      address: address,
      assignedRepId: assignedRepId,
      createdBy: createdBy,
      isActive: isActive,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt,
      updatedAt: updatedAt,
      brandId: brandId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'assigned_rep_id': assignedRepId,
      'created_by': createdBy,
      'is_active': isActive,
    };
  }
}
