import re, os
file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\supervisor_home_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for i, line in enumerate(lines):
    if "إضافة طبيب" in line:
        start = max(0, i - 15)
        end = min(len(lines), i + 15)
        print('\n'.join(lines[start:end]))
        break
