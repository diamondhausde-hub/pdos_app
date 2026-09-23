import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\brand_activity_log_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace ActivityLogEntry mock class with import
content = content.replace("class ActivityLogEntry {", "/*class ActivityLogEntry {")
content = content.replace("  });\n}", "  });\n}*/")
if "import '../../../models/activity_log_model.dart';" not in content:
    content = content.replace("import '../../../core/providers/brand_provider.dart';", "import '../../../core/providers/brand_provider.dart';\nimport '../../../models/activity_log_model.dart';\nimport '../../../core/providers/data_providers.dart';")

content = content.replace("List<ActivityLogEntry> _getMockLogs", "/*List<ActivityLogEntry> _getMockLogs")
content = content.replace("    ];\n  }", "    ];\n  }*/")

content = content.replace("ActivityLogEntry", "ActivityLogModel")

content = content.replace("final logs = _getMockLogs(b.id);", "final logs = ref.watch(activityLogsProvider({'brandId': b.id, 'dateFilter': _dateFilter})).value ?? [];")

content = content.replace("log.repName", "log.repName ?? 'Unknown'")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("brand_activity_log_screen.dart updated")
