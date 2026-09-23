class DailyRevenueModel {
  final String date;
  final double revenue;

  DailyRevenueModel({required this.date, required this.revenue});

  factory DailyRevenueModel.fromJson(Map<String, dynamic> json) {
    return DailyRevenueModel(
      date: json['date'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}

class MonthlyRevenueModel {
  final String month;
  final double revenue;

  MonthlyRevenueModel({required this.month, required this.revenue});

  factory MonthlyRevenueModel.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenueModel(
      month: json['month'] as String,
      revenue: (json['revenue'] as num).toDouble(),
    );
  }
}

class AnalyticsModel {
  final double totalRevenue;
  final int totalVisits;
  final int visitsCompleted;
  final double avgVisitsPerRep;
  final double targetCompletionPercent;
  final List<RepPerformanceModel> topReps;
  final List<ProductPerformanceModel> topProducts;

  AnalyticsModel({
    required this.totalRevenue,
    required this.totalVisits,
    required this.visitsCompleted,
    required this.avgVisitsPerRep,
    required this.targetCompletionPercent,
    required this.topReps,
    required this.topProducts,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalVisits: json['total_visits'] as int? ?? json['visits_completed'] as int, // Fallback for safety
      visitsCompleted: json['visits_completed'] as int,
      avgVisitsPerRep: (json['avg_visits_per_rep'] as num).toDouble(),
      targetCompletionPercent: (json['target_completion_percent'] as num).toDouble(),
      topReps: (json['top_reps'] as List).map((e) => RepPerformanceModel.fromJson(e)).toList(),
      topProducts: (json['top_products'] as List).map((e) => ProductPerformanceModel.fromJson(e)).toList(),
    );
  }
}

class RepPerformanceModel {
  final int rank;
  final String repName;
  final int totalVisits;
  final double totalRevenue;

  RepPerformanceModel({
    required this.rank,
    required this.repName,
    required this.totalVisits,
    required this.totalRevenue,
  });

  factory RepPerformanceModel.fromJson(Map<String, dynamic> json) {
    return RepPerformanceModel(
      rank: json['rank'] as int,
      repName: json['rep_name'] as String,
      totalVisits: json['total_visits'] as int,
      totalRevenue: (json['total_revenue'] as num).toDouble(),
    );
  }
}

class ProductPerformanceModel {
  final int rank;
  final String productName;
  final int unitsSold;
  final double totalRevenue;

  ProductPerformanceModel({
    required this.rank,
    required this.productName,
    required this.unitsSold,
    required this.totalRevenue,
  });

  factory ProductPerformanceModel.fromJson(Map<String, dynamic> json) {
    return ProductPerformanceModel(
      rank: json['rank'] as int,
      productName: json['product_name'] as String,
      unitsSold: json['units_sold'] as int,
      totalRevenue: (json['total_revenue'] as num).toDouble(),
    );
  }
}
