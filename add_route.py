import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\router\app_router.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

import_statement = "import '../../features/rep/screens/rep_tasks_tab.dart';\n"
if "rep_tasks_tab.dart" not in content:
    # Add import near rep routes
    content = content.replace(
        "import '../../features/rep/screens/my_day_tab.dart';", 
        "import '../../features/rep/screens/my_day_tab.dart';\n" + import_statement
    )

route_code = '''
      GoRoute(
        path: '/rep/tasks',
        builder: (context, state) => const RepTasksTab(),
      ),
'''
if "'/rep/tasks'" not in content:
    content = content.replace(
        "// Delegate routes",
        "// Delegate routes\n" + route_code
    )

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Added rep/tasks route")
