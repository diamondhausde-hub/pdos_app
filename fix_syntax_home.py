import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\supervisor_home_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("              children: [\n),\n                _buildActionCard(", "              children: [\n                _buildActionCard(")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed syntax")
