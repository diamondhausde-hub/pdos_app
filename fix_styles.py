import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\rep_tasks_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix titleLg -> h2 or headlineMd
content = content.replace('AppTextStyles.titleLg', 'AppTextStyles.headlineMd')
# Fix titleMd -> h3 or headlineSm
content = content.replace('AppTextStyles.titleMd', 'AppTextStyles.headlineSm')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Replaced text styles in rep_tasks_tab.dart")
