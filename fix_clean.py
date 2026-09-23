import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Revert all the Material(...ListTile( mess
content = re.sub(r'Material\(color: Colors\.transparent, child: ' + '*', '', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Cleaned up task_management_screen.dart")
