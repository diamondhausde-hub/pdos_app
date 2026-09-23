import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\task_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import '../models/activity_log_model.dart';", "import '../models/brand_activity_log_model.dart';")
content = content.replace("ActivityLogModel", "BrandActivityLogModel")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
