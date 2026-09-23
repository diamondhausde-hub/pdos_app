class SupervisorTask {
  final String id;
  final String repId;
  final String? repName;
  final String brandId;
  final String? brandName;
  final String? brandColor;
  final String? supervisorId;
  final String? supervisorName;
  final String taskType;
  final String? targetType;
  final String? targetId;
  final String? targetName;
  final String? productId;
  final String? productName;
  final int? quantityTarget;
  final DateTime? dueDate;
  final String status;
  final String? notes;
  final String? priority;
  final String? progressNote;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? completedAt;
  final String? purpose;
  final String? visitSubtype;
  final DateTime? scheduledDatetime;
  final String? rejectionReport;
  final String? reminderOffset;
  final DateTime? acceptedAt;
  final String? visitId;

  SupervisorTask({
    required this.id,
    required this.repId,
    this.repName,
    required this.brandId,
    this.brandName,
    this.brandColor,
    this.supervisorId,
    this.supervisorName,
    required this.taskType,
    this.targetType,
    this.targetId,
    this.targetName,
    this.productId,
    this.productName,
    this.quantityTarget,
    this.dueDate,
    required this.status,
    this.notes,
    this.priority,
    this.progressNote,
    this.isDeleted = false,
    this.createdAt,
    this.completedAt,
    this.purpose,
    this.visitSubtype,
    this.scheduledDatetime,
    this.rejectionReport,
    this.reminderOffset,
    this.acceptedAt,
    this.visitId,
  });

  factory SupervisorTask.fromJson(Map<String, dynamic> json) {
    return SupervisorTask(
      id: json['id'] as String,
      repId: json['rep_id'] as String,
      repName: json['rep_name'] as String?,
      brandId: json['brand_id'] as String,
      brandName: json['brand_name'] as String?,
      brandColor: json['brand_color'] as String?,
      supervisorId: json['supervisor_id'] as String?,
      supervisorName: json['supervisor_name'] as String?,
      taskType: json['task_type'] as String,
      targetType: json['target_type'] as String?,
      targetId: json['target_id'] as String?,
      targetName: json['target_name'] as String?,
      productId: json['product_id'] as String?,
      productName: json['product_name'] as String?,
      quantityTarget: json['quantity_target'] as int?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      status: json['status'] ?? 'new',
      notes: json['notes'] as String?,
      priority: json['priority'] as String?,
      progressNote: json['progress_note'] as String?,
      isDeleted: json['is_deleted'] == true,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
      purpose: json['purpose'] as String?,
      visitSubtype: json['visit_subtype'] as String?,
      scheduledDatetime: json['scheduled_datetime'] != null ? DateTime.parse(json['scheduled_datetime']) : null,
      rejectionReport: json['rejection_report'] as String?,
      reminderOffset: json['reminder_offset'] as String?,
      acceptedAt: json['accepted_at'] != null ? DateTime.parse(json['accepted_at']) : null,
      visitId: json['visit_id'] as String?,
    );
  }

  SupervisorTask copyWith({
    String? status,
    String? progressNote,
    String? notes,
    String? priority,
    String? purpose,
    String? visitSubtype,
    DateTime? scheduledDatetime,
    String? rejectionReport,
    String? reminderOffset,
    DateTime? acceptedAt,
    String? visitId,
  }) {
    return SupervisorTask(
      id: id,
      repId: repId,
      repName: repName,
      brandId: brandId,
      brandName: brandName,
      brandColor: brandColor,
      supervisorId: supervisorId,
      supervisorName: supervisorName,
      taskType: taskType,
      targetType: targetType,
      targetId: targetId,
      targetName: targetName,
      productId: productId,
      productName: productName,
      quantityTarget: quantityTarget,
      dueDate: dueDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      priority: priority ?? this.priority,
      progressNote: progressNote ?? this.progressNote,
      isDeleted: isDeleted,
      createdAt: createdAt,
      completedAt: completedAt,
      purpose: purpose ?? this.purpose,
      visitSubtype: visitSubtype ?? this.visitSubtype,
      scheduledDatetime: scheduledDatetime ?? this.scheduledDatetime,
      rejectionReport: rejectionReport ?? this.rejectionReport,
      reminderOffset: reminderOffset ?? this.reminderOffset,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      visitId: visitId ?? this.visitId,
    );
  }

  /// Convenience getters
  bool get isOverdue =>
      dueDate != null && dueDate!.isBefore(DateTime.now()) && status != 'done';

  String get taskTypeLabel {
    switch (taskType) {
      case 'visit': return 'زيارة';
      case 'sales': return 'مبيعات';
      case 'stock': return 'جرد';
      case 'target': return 'هدف';
      case 'event': return 'فعالية';
      default: return taskType;
    }
  }

  String get statusLabel {
    switch (status) {
      case 'pending': return 'معلقة';
      case 'accepted': return 'مقبولة';
      case 'rejected': return 'مرفوضة';
      case 'scheduled': return 'مجدولة';
      case 'in_progress': return 'قيد التنفيذ';
      case 'completed': return 'مكتملة';
      case 'done': return 'مكتملة';
      case 'new': return 'جديدة';
      default: return status;
    }
  }

  String get purposeLabel {
    switch (purpose) {
      case 'product': return 'منتج معين';
      case 'targeting': return 'استهداف';
      case 'accounting': return 'حسابات';
      default: return purpose ?? '';
    }
  }

  String get visitSubtypeLabel {
    switch (visitSubtype) {
      case 'doctor': return 'طبيب';
      case 'pharmacy': return 'صيدلية';
      default: return visitSubtype ?? '';
    }
  }

  bool get canStart {
    if (status != 'scheduled') return false;
    if (scheduledDatetime == null) return true;
    return DateTime.now().isAfter(scheduledDatetime!) || DateTime.now().isAtSameMomentAs(scheduledDatetime!);
  }

  String get priorityLabel {
    switch (priority) {
      case 'urgent':
        return 'عاجل';
      case 'high':
        return 'مهم';
      default:
        return 'عادي';
    }
  }
}
