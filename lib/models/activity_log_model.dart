class ActivityLogModel {
  final String id;
  final String? repId;
  final String brandId;
  final String? taskId;
  final String? activityType;
  final String? targetType;
  final String? targetId;
  final DateTime? loggedAt;
  final String? notes;
  final String status;
  final String? repName;

  ActivityLogModel({
    required this.id,
    this.repId,
    required this.brandId,
    this.taskId,
    this.activityType,
    this.targetType,
    this.targetId,
    this.loggedAt,
    this.notes,
    required this.status,
    this.repName,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id'] as String,
      repId: json['rep_id'] as String?,
      brandId: json['brand_id'] as String,
      taskId: json['task_id'] as String?,
      activityType: json['activity_type'] as String?,
      targetType: json['target_type'] as String?,
      targetId: json['target_id'] as String?,
      loggedAt: json['logged_at'] != null ? DateTime.parse(json['logged_at']) : null,
      notes: json['notes'] as String?,
      status: json['status'] ?? 'completed',
      repName: json['rep_name'] as String?,
    );
  }
}
