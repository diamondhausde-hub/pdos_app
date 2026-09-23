class SystemSettingModel {
  final String key;
  final String value;
  final String? description;
  final DateTime updatedAt;

  SystemSettingModel({
    required this.key,
    required this.value,
    this.description,
    required this.updatedAt,
  });

  factory SystemSettingModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingModel(
      key: json['key'],
      value: json['value'],
      description: json['description'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
