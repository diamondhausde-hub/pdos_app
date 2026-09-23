import 'package:flutter/foundation.dart';

/// Product model — maps to public.products
@immutable
class ProductModel {
  final String id;
  final String name;
  final String? category;
  final String? barcode;
  final String? imageUrl;
  final int stockQty;
  final DateTime? expiryDate;
  final int minThreshold;
  final int expiryAlertDays;
  final double? unitPrice;
  final String? addedBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? brandId;

  const ProductModel({
    required this.id,
    required this.name,
    this.category,
    this.barcode,
    this.imageUrl,
    this.stockQty = 0,
    this.expiryDate,
    this.minThreshold = 0,
    this.expiryAlertDays = 30,
    this.unitPrice,
    this.addedBy,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.brandId,
  });

  /// Whether stock is below minimum threshold
  bool get isLowStock => stockQty <= minThreshold;

  /// Whether product is expiring within alert window
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= expiryAlertDays && daysUntilExpiry >= 0;
  }

  /// Whether product has already expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  /// Whether this product has any alert (low stock or expiring)
  bool get hasAlert => isLowStock || isExpiringSoon || isExpired;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String?,
      barcode: json['barcode'] as String?,
      imageUrl: json['image_url'] as String?,
      stockQty: json['stock_qty'] as int? ?? 0,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date'] as String) : null,
      minThreshold: json['min_threshold'] as int? ?? 0,
      expiryAlertDays: json['expiry_alert_days'] as int? ?? 30,
      unitPrice: (json['price'] as num?)?.toDouble(),
      addedBy: json['added_by'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      brandId: json['brand_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'barcode': barcode,
      'image_url': imageUrl,
      'stock_qty': stockQty,
      'expiry_date': expiryDate?.toIso8601String().split('T').first,
      'min_threshold': minThreshold,
      'expiry_alert_days': expiryAlertDays,
      'price': unitPrice,
      'added_by': addedBy,
      'is_active': isActive,
      'brand_id': brandId,
    };
  }
}
