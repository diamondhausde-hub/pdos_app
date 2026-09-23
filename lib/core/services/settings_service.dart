import '../models/system_setting.dart';
import 'api_service.dart';
import 'package:dio/dio.dart';

class SettingsService {
  final ApiService _api;

  SettingsService(this._api);

  Future<List<SystemSettingModel>> getSettings() async {
    final response = await _api.dio.get('/settings');
    return (response.data as List).map((e) => SystemSettingModel.fromJson(e)).toList();
  }

  Future<SystemSettingModel> updateSetting(String key, double value) async {
    try {
      final response = await _api.dio.put(
        '/settings/$key',
        data: {'value': value},
      );
      return SystemSettingModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception(e.response?.data['detail'] ?? 'Validation error');
      }
      throw Exception('Failed to update setting: ${e.message}');
    }
  }
}
