import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\router\app_router.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Update import from task_assignment_screen to task_management_screen
content = content.replace(
    "import '../../features/supervisor/screens/task_assignment_screen.dart';", 
    "import '../../features/supervisor/screens/task_management_screen.dart';"
)

# Replace TaskAssignmentScreen() with TaskManagementScreen()
content = content.replace('TaskAssignmentScreen()', 'TaskManagementScreen()')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated app_router.dart")
