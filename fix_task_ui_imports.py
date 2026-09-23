import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import '../../../models/task_model.dart';", "import '../../../core/models/task_model.dart';")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
