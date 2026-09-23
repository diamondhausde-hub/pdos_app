import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// User roles in the PDOS system
enum UserRole {
  admin,
  generalManager,
  overseer,
  supervisor,
  rep;

  /// Parse role from string (database value)
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (e) => e.name == value || _legacyMap[value] == e,
      orElse: () => UserRole.rep,
    );
  }

  static const _legacyMap = <String, UserRole>{
    'general_manager': UserRole.generalManager,
  };

  /// Display name for UI
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.generalManager:
        return 'General Manager';
      case UserRole.overseer:
        return 'Overseer';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.rep:
        return 'Rep';
    }
  }

  /// The value sent to the backend API
  String get apiValue {
    switch (this) {
      case UserRole.generalManager:
        return 'general_manager';
      default:
        return name;
    }
  }
}

/// User profile model — maps to public.users table
@immutable
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final UserRole role;
  final String? region;
  final String? supervisorId;
  final String? profileImageUrl;
  final bool isActive;
  final bool hasCompletedOnboarding;
  final bool mustChangePassword;
  final String? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? lastLat;
  final double? lastLng;
  final DateTime? lastLocationUpdate;
  final String? brandId; // null for admin and generalManager
  final List<String> brandIds;

  String? get fullProfileImageUrl {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) return null;
    // Reject placeholder/sentinel values stored during onboarding skip
    if (profileImageUrl == 'default' || profileImageUrl == 'skipped') return null;
    if (profileImageUrl!.startsWith('http')) return profileImageUrl;
    final baseUrl = dotenv.env['API_BASE_URL']?.replaceAll(RegExp(r'/$'), '') ?? '';
    return '$baseUrl$profileImageUrl';
  }

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.role,
    this.region,
    this.supervisorId,
    this.profileImageUrl,
    this.isActive = true,
    this.hasCompletedOnboarding = false,
    this.mustChangePassword = true,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.lastLat,
    this.lastLng,
    this.lastLocationUpdate,
    this.brandId,
    this.brandIds = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      role: UserRole.fromString(json['role'] as String? ?? 'rep'),
      region: json['region'] as String?,
      supervisorId: json['supervisor_id'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      hasCompletedOnboarding: json['has_completed_onboarding'] as bool? ?? false,
      mustChangePassword: json['must_change_password'] as bool? ?? true,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      lastLat: (json['last_lat'] as num?)?.toDouble(),
      lastLng: (json['last_lng'] as num?)?.toDouble(),
      lastLocationUpdate: json['last_location_update'] != null ? DateTime.parse(json['last_location_update'] as String) : null,
      brandId: json['brand_id'] as String?,
      brandIds: (json['brand_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role.apiValue,
      'region': region,
      'supervisor_id': supervisorId,
      'profile_image_url': profileImageUrl,
      'is_active': isActive,
      'has_completed_onboarding': hasCompletedOnboarding,
      'must_change_password': mustChangePassword,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_lat': lastLat,
      'last_lng': lastLng,
      'last_location_update': lastLocationUpdate?.toIso8601String(),
      'brand_id': brandId,
      'brand_ids': brandIds,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    UserRole? role,
    String? region,
    String? supervisorId,
    String? profileImageUrl,
    bool? isActive,
    bool? hasCompletedOnboarding,
    bool? mustChangePassword,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? lastLat,
    double? lastLng,
    DateTime? lastLocationUpdate,
    String? brandId,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      region: region ?? this.region,
      supervisorId: supervisorId ?? this.supervisorId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      mustChangePassword: mustChangePassword ?? this.mustChangePassword,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastLat: lastLat ?? this.lastLat,
      lastLng: lastLng ?? this.lastLng,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      brandId: brandId ?? this.brandId,
    );
  }
}
