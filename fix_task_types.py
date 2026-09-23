import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix types in where
content = content.replace('final filteredTasks = allTasks.where((t) {', 'final filteredTasks = allTasks.where((SupervisorTask t) {')
content = content.replace('t?.brandId', 't.brandId')
content = content.replace('t?.repId', 't.repId')
content = content.replace('t?.taskType', 't.taskType')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("task_assignment_screen.dart typed")
