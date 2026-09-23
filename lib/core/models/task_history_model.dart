class TaskHistoryModel {
  final String id;
  final String taskId;
  final String action;
  final String? oldStatus;
  final String? newStatus;
  final String changedBy;
  final String? changedByName;
  final String? note;
  final DateTime createdAt;

  TaskHistoryModel({
    required this.id,
    required this.taskId,
    required this.action,
    this.oldStatus,
    this.newStatus,
    required this.changedBy,
    this.changedByName,
    this.note,
    required this.createdAt,
  });

  factory TaskHistoryModel.fromJson(Map<String, dynamic> json) {
    return TaskHistoryModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      action: json['action'] as String,
      oldStatus: json['old_status'] as String?,
      newStatus: json['new_status'] as String?,
      changedBy: json['changed_by'] as String,
      changedByName: json['changed_by_name'] as String?,
      note: json['note'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
