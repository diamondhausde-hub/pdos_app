// ignore_for_file: avoid_print
import '../models/activity_log_model.dart';
import '../services/api_service.dart';

class LogRepository {
  final ApiService _api;

  LogRepository(this._api);

  Future<List<ActivityLogModel>> getLogs({String? logType, String? brandId, int limit = 100}) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (logType != null && logType != 'All') {
        queryParams['log_type'] = logType.toLowerCase();
      }
      if (brandId != null) {
        queryParams['brand_id'] = brandId;
      }
      final response = await _api.dio.get('/logs', queryParameters: queryParams);
      return (response.data as List).map((e) => ActivityLogModel.fromJson(e)).toList();
    } catch (e) {
      print('Failed to fetch logs: $e');
      return [];
    }
  }

  Future<ActivityLogModel?> getLogById(String id) async {
    try {
      final response = await _api.dio.get('/logs');
      final logs = (response.data as List).map((e) => ActivityLogModel.fromJson(e)).toList();
      return logs.where((l) => l.id == id).firstOrNull;
    } catch (e) {
      print('Failed to fetch log: $e');
      return null;
    }
  }
}
