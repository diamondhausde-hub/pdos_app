import '../models/brand_activity_log_model.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
class TaskRepository {
  final ApiService api;

  TaskRepository(this.api);

  // ─── Tasks CRUD ─────────────────────────────────────────────

  Future<List<SupervisorTask>> getTasks({String? brandId, String? repId, String? status}) async {
    final query = <String, dynamic>{};
    if (brandId != null) query['brand_id'] = brandId;
    if (repId != null) query['rep_id'] = repId;
    if (status != null) query['status'] = status;

    final response = await api.dio.get('/tasks/', queryParameters: query);
    final data = response.data as List;
    return data.map((e) => SupervisorTask.fromJson(e)).toList();
  }

  Future<SupervisorTask> createTask(Map<String, dynamic> taskData) async {
    final response = await api.dio.post('/tasks/', data: taskData);
    return SupervisorTask.fromJson(response.data);
  }

  Future<SupervisorTask> updateTaskStatus(
    String taskId,
    String status, {
    String? progressNote,
    String? priority,
    String? notes,
    String? rejectionReport,
    String? reminderOffset,
    String? visitId,
  }) async {
    final data = <String, dynamic>{'status': status};
    if (progressNote != null) data['progress_note'] = progressNote;
    if (priority != null) data['priority'] = priority;
    if (notes != null) data['notes'] = notes;
    if (rejectionReport != null) data['rejection_report'] = rejectionReport;
    if (reminderOffset != null) data['reminder_offset'] = reminderOffset;
    if (visitId != null) data['visit_id'] = visitId;

    final response = await api.dio.patch('/tasks/$taskId', data: data);
    return SupervisorTask.fromJson(response.data);
  }

  Future<void> deleteTask(String id) async {
    await api.dio.delete('/tasks/$id');
  }

  // ─── Task History ──────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getTaskHistory(String taskId) async {
    final response = await api.dio.get('/tasks/$taskId/history');
    return List<Map<String, dynamic>>.from(response.data);
  }

  // ─── Search Targets (Autocomplete) ─────────────────────────

  Future<List<Map<String, dynamic>>> searchTargets(String query, {String? type}) async {
    if (query.isEmpty) return [];
    final params = <String, dynamic>{'q': query};
    if (type != null) params['type'] = type;

    final response = await api.dio.get('/tasks/search-targets', queryParameters: params);
    return List<Map<String, dynamic>>.from(response.data);
  }

  // ─── Activity Logs ─────────────────────────────────────────

  Future<List<BrandActivityLogModel>> getActivityLogs({
    String? brandId,
    String? repId,
    String? dateFilter,
  }) async {
    final query = <String, dynamic>{};
    if (brandId != null && brandId != 'All') query['brand_id'] = brandId;
    if (repId != null && repId != 'All') query['rep_id'] = repId;
    if (dateFilter != null) {
      if (dateFilter == 'Today' || dateFilter == 'اليوم') {
        query['date_filter'] = 'today';
      } else if (dateFilter == 'This Week' || dateFilter == 'هذا الأسبوع') {
        query['date_filter'] = 'week';
      } else if (dateFilter == 'This Month' || dateFilter == 'هذا الشهر') {
        query['date_filter'] = 'month';
      }
    }

    final response = await api.dio.get('/tasks/logs', queryParameters: query);
    final data = response.data as List;
    return data.map((e) => BrandActivityLogModel.fromJson(e)).toList();
  }
}
