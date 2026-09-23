import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("Text('U?O'U, O U,O-U?O,: ')", "Text('فشل الحفظ: $e')")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed syntax error")
