import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\brand_activity_log_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import '../../../models/activity_log_model.dart';", "import '../../../core/models/brand_activity_log_model.dart';")
content = content.replace("ActivityLogModel", "BrandActivityLogModel")
content = content.replace("log.loggedAt.hour", "log.loggedAt?.hour")
content = content.replace("log.loggedAt.minute", "log.loggedAt?.minute")
content = content.replace("DataCell(Text(log.activityType)),", "DataCell(Text(log.activityType ?? '-')),")
content = content.replace("DataCell(Text(log.targetName ?? '-')),", "DataCell(Text(log.targetId ?? '-')),")
content = content.replace("DataCell(Text(log.notes)),", "DataCell(Text(log.notes ?? '-')),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
