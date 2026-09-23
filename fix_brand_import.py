import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import '../../../core/providers/data_providers.dart';", "import '../../../core/providers/data_providers.dart';\nimport '../../../core/providers/brand_provider.dart';")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Imported brand_provider.dart")
