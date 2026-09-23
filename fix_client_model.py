import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\models\client_model.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

import re

# Add brandId
content = content.replace("final String repId;", "final String repId;\n  final String? brandId;")
content = content.replace("required this.repId,", "required this.repId,\n    this.brandId,")
content = content.replace("repId: json['rep_id'] as String,", "repId: json['rep_id'] as String,\n        brandId: json['brand_id'] as String?,")
content = content.replace("'rep_id': repId,", "'rep_id': repId,\n        'brand_id': brandId,")
content = content.replace("String? repId,", "String? repId,\n    String? brandId,")
content = content.replace("repId: repId ?? this.repId,", "repId: repId ?? this.repId,\n        brandId: brandId ?? this.brandId,")
content = content.replace("repId: local.repId,", "repId: local.repId,\n        brandId: local.brandId,")
content = content.replace("repId: repId,", "repId: repId,\n        brandId: drift.Value(brandId),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("ClientModel updated")
