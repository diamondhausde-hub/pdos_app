import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\models\user_model.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add brandIds field
content = content.replace('  final String? brandId; // null for admin and generalManager', '  final String? brandId; // null for admin and generalManager\n  final List<String> brandIds;')

# Add to constructor
content = content.replace('    this.brandId,', '    this.brandId,\n    this.brandIds = const [],')

# Add to fromJson
content = content.replace("      brandId: json['brand_id'] as String?,", "      brandId: json['brand_id'] as String?,\n      brandIds: (json['brand_ids'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],")

# Add to toJson
content = content.replace("      'brand_id': brandId,", "      'brand_id': brandId,\n      'brand_ids': brandIds,")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated user_model.dart")
