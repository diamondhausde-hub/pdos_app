import '../models/target_model.dart';
import '../services/api_service.dart';

class TargetRepository {
  final ApiService _api = ApiService.instance;

  Future<List<TargetModel>> getTargets({String? brandId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (brandId != null) queryParams['brand_id'] = brandId;
      final response = await _api.dio.get('/targets', queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final data = response.data as List;
      return data.map((e) => TargetModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }
  Future<TargetModel> createTarget(Map<String, dynamic> data) async {
    final response = await _api.dio.post('/targets', data: data);
    return TargetModel.fromJson(response.data);
  }

  Future<TargetModel> updateTarget(String id, Map<String, dynamic> data) async {
    final response = await _api.dio.put('/targets/$id', data: data);
    return TargetModel.fromJson(response.data);
  }

  Future<void> deleteTarget(String id) async {
    await _api.dio.delete('/targets/$id');
  }
}
