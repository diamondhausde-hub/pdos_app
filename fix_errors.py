import sys

# Fix data_providers.dart imports
file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import '../models/activity_log_model.dart';", "")
content = content.replace("import '../models/brand_activity_log_model.dart';", "")
content = "import '../models/brand_activity_log_model.dart';\n" + content

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

# Fix general_manager_logs_tab.dart
file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\general_manager\screens\general_manager_logs_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()
content = content.replace('log.logType ==', 'log.logType ==') # Wait, log.logType isn't nullable if it's correct?
# Let's just fix it using replace
content = content.replace('log.logType', 'log?.logType')
content = content.replace('log?.logType ==', 'log.logType ==') # rollback
content = content.replace('t.logType', 't?.logType') 
# Let's just use Python script to safely replace
