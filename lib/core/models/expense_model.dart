import 'package:flutter/material.dart';

@immutable
class ExpenseModel {
  final String id;
  final String? visitId;
  final String repId;
  final String category;
  final double amount;
  final String? description;
  final String? receiptImageUrl;
  final String status;
  final String? rejectionReason;
  final bool requiresAdminApproval;
  final bool requiresGmApproval;
  final String? approvedBy;
  final DateTime? approvedAt;
  final DateTime createdAt;
  final String? repName;

  const ExpenseModel({
    required this.id,
    this.visitId,
    required this.repId,
    required this.category,
    required this.amount,
    this.description,
    this.receiptImageUrl,
    this.status = 'pending',
    this.rejectionReason,
    this.requiresAdminApproval = false,
    this.requiresGmApproval = false,
    this.approvedBy,
    this.approvedAt,
    required this.createdAt,
    this.repName,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      visitId: json['visit_id'] as String?,
      repId: json['rep_id'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String?,
      receiptImageUrl: json['receipt_image_url'] as String?,
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejection_reason'] as String?,
      requiresAdminApproval: json['requires_admin_approval'] as bool? ?? false,
      requiresGmApproval: json['requires_gm_approval'] as bool? ?? false,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      repName: json['rep_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_id': visitId,
      'category': category,
      'amount': amount,
      'description': description,
    };
  }

  IconData get categoryIcon {
    switch (category) {
      case 'transport': return Icons.directions_car;
      case 'meals': return Icons.restaurant;
      case 'supplies': return Icons.inventory;
      default: return Icons.receipt;
    }
  }
}
