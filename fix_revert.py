import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Let's revert my changes by checkout from git and doing a simpler fix:
# wrap ListTile with Material(color: Colors.transparent, child: ListTile(...))
