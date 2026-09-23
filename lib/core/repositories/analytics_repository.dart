import '../services/api_service.dart';
import '../models/analytics_models.dart';
import '../models/overview_model.dart';

class AnalyticsRepository {
  final ApiService _api = ApiService.instance;

  Future<AnalyticsModel> getAnalytics(DateTime start, DateTime end, {String? brandId}) async {
    final queryParams = <String, dynamic>{
      'start_date': start.toIso8601String().split('T')[0],
      'end_date': end.toIso8601String().split('T')[0],
    };
    if (brandId != null) {
      queryParams['brand_id'] = brandId;
    }
    final response = await _api.dio.get('/analytics', queryParameters: queryParams);
    return AnalyticsModel.fromJson(response.data);
  }

  Future<List<DailyRevenueModel>> getDailyRevenue(DateTime start, DateTime end) async {
    final response = await _api.dio.get('/analytics/daily-revenue', queryParameters: {
      'start_date': start.toIso8601String().split('T')[0],
      'end_date': end.toIso8601String().split('T')[0],
    });
    return (response.data as List).map((e) => DailyRevenueModel.fromJson(e)).toList();
  }

  Future<List<MonthlyRevenueModel>> getMonthlyRevenue(int year) async {
    final response = await _api.dio.get('/analytics/monthly-revenue', queryParameters: {
      'year': year,
    });
    return (response.data as List).map((e) => MonthlyRevenueModel.fromJson(e)).toList();
  }

  Future<SystemOverviewModel> getSystemOverview({String? brandId}) async {
    final response = await _api.dio.get(
      '/analytics/system-overview',
      queryParameters: brandId != null ? {'brand_id': brandId} : null,
    );
    return SystemOverviewModel.fromJson(response.data);
  }
}
