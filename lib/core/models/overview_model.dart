import 'package:flutter/foundation.dart';

@immutable
class RegionCoverageModel {
  final String region;
  final int visitsCompleted;
  final int totalCenters;
  final double coveragePercent;

  const RegionCoverageModel({
    required this.region,
    required this.visitsCompleted,
    required this.totalCenters,
    required this.coveragePercent,
  });

  factory RegionCoverageModel.fromJson(Map<String, dynamic> json) {
    return RegionCoverageModel(
      region: json['region'] as String,
      visitsCompleted: json['visits_completed'] as int,
      totalCenters: json['total_centers'] as int,
      coveragePercent: (json['coverage_percent'] as num).toDouble(),
    );
  }
}

@immutable
class SystemOverviewModel {
  final double totalRevenue;
  final int totalUsers;
  final int totalCenters;
  final int totalProducts;
  final int visitsToday;
  final int lowStockCount;
  final int pendingAppointments;
  final List<RegionCoverageModel> regionCoverage;

  const SystemOverviewModel({
    required this.totalRevenue,
    required this.totalUsers,
    required this.totalCenters,
    required this.totalProducts,
    required this.visitsToday,
    required this.lowStockCount,
    required this.pendingAppointments,
    required this.regionCoverage,
  });

  factory SystemOverviewModel.fromJson(Map<String, dynamic> json) {
    return SystemOverviewModel(
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      totalUsers: json['total_users'] as int,
      totalCenters: json['total_centers'] as int,
      totalProducts: json['total_products'] as int,
      visitsToday: json['visits_today'] as int,
      lowStockCount: json['low_stock_count'] as int,
      pendingAppointments: json['pending_appointments'] as int,
      regionCoverage: (json['region_coverage'] as List)
          .map((e) => RegionCoverageModel.fromJson(e))
          .toList(),
    );
  }
}
