import os
import shutil

os.rename(r'lib\models\task_model.dart', r'lib\core\models\task_model.dart')
os.rename(r'lib\repositories\task_repository.dart', r'lib\core\repositories\task_repository.dart')

brand_activity_log_code = '''
class BrandActivityLogModel {
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
  final String? brandName;

  BrandActivityLogModel({
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
    this.brandName,
  });

  factory BrandActivityLogModel.fromJson(Map<String, dynamic> json) {
    return BrandActivityLogModel(
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
      brandName: json['brand_name'] as String?,
    );
  }
}
'''
with open(r'lib\core\models\brand_activity_log_model.dart', 'w', encoding='utf-8') as f:
    f.write(brand_activity_log_code)

print('Files moved and created.')
