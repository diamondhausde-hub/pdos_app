import 'package:flutter/foundation.dart';

@immutable
class TargetModel {
  final String id;
  final String productId;
  final String? repId;
  final String? brandId;
  final DateTime periodStart;
  final DateTime periodEnd;
  final int targetQty;
  final int achievedQty;
  final String? notes;
  final int viewCount;
  final bool userViewed;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? productName;
  final String? repName;

  const TargetModel({
    required this.id,
    required this.productId,
    this.repId,
    this.brandId,
    required this.periodStart,
    required this.periodEnd,
    this.targetQty = 0,
    this.achievedQty = 0,
    this.notes,
    this.viewCount = 0,
    this.userViewed = false,
    required this.createdAt,
    required this.updatedAt,
    this.productName,
    this.repName,
  });

  double get progress {
    if (targetQty == 0) return 0.0;
    return (achievedQty / targetQty).clamp(0.0, 1.0);
  }

  double get progressPercent => progress * 100;

  bool get isAchieved => achievedQty >= targetQty;

  bool get isGlobal => repId == null;

  factory TargetModel.fromJson(Map<String, dynamic> json) {
    return TargetModel(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      repId: json['rep_id'] as String?,
      brandId: json['brand_id'] as String?,
      periodStart: DateTime.parse(json['period_start'] as String),
      periodEnd: DateTime.parse(json['period_end'] as String),
      targetQty: json['target_qty'] as int? ?? 0,
      achievedQty: json['achieved_qty'] as int? ?? 0,
      notes: json['notes'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      userViewed: json['user_viewed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      productName: json['product_name'] as String?,
      repName: json['rep_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'rep_id': repId,
      'brand_id': brandId,
      'period_start': periodStart.toIso8601String().split('T').first,
      'period_end': periodEnd.toIso8601String().split('T').first,
      'target_qty': targetQty,
      'notes': notes,
      'achieved_qty': achievedQty,
    };
  }
}