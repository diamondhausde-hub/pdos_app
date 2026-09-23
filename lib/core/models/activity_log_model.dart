import 'package:flutter/material.dart';

@immutable
class ActivityLogModel {
  final String id;
  final String? userId;
  final String userName;
  final String action;
  final String logType;
  final String? relatedId;
  final DateTime createdAt;

  const ActivityLogModel({
    required this.id,
    this.userId,
    required this.userName,
    required this.action,
    required this.logType,
    this.relatedId,
    required this.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      userName: json['user_name'] as String,
      action: json['action'] as String,
      logType: json['log_type'] as String,
      relatedId: json['related_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
