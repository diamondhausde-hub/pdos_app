import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'import \'dart:async\';' not in content:
    content = "import 'dart:async';\n" + content

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Imported dart:async")
