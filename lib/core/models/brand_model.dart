import 'package:flutter/foundation.dart';

@immutable
class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;
  final bool isActive;
  final DateTime createdAt;

  const BrandModel({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.isActive,
    required this.createdAt,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo_url': logoUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }

  BrandModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
