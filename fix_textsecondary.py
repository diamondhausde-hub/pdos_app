import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix AppColors.textSecondary -> AppColors.onSurfaceVariant
content = content.replace('AppColors.textSecondary', 'AppColors.onSurfaceVariant')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Replaced textSecondary")
