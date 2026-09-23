import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("return all.where((u) => u.brandId == brandId || u.role.name == 'general_manager' || u.role.name == 'admin').toList();", "return all.where((u) => u.brandId == brandId || u.brandIds.contains(brandId) || u.role.name == 'general_manager' || u.role.name == 'admin').toList();")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated data_providers.dart")
