import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacement = """    final taskData = {
      'brand_id': widget.parentRef.read(selectedBrandIdProvider),
      'rep_id': _selectedRepId!,
      'task_type': _taskType,"""

content = content.replace("    final taskData = {\n      'rep_id': _selectedRepId!,\n      'task_type': _taskType,", replacement)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Added brand_id")
