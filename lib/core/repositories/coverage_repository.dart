import '../models/coverage_model.dart';
import '../services/api_service.dart';

class CoverageRepository {
  final ApiService _apiService;

  CoverageRepository(this._apiService);

  Future<List<CoverageCenter>> getCoverage({String? brandId}) async {
    final queryParams = brandId != null ? {'brand_id': brandId} : null;
    final response = await _apiService.dio.get('/centers/coverage', queryParameters: queryParams);
    final data = response.data as List;
    return data.map((json) => CoverageCenter.fromJson(json)).toList();
  }
}
