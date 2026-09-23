import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace return ListTile( with return Material(color: Colors.transparent, child: ListTile(
content = content.replace('return ListTile(', 'return Material(color: Colors.transparent, child: ListTile(')
content = content.replace('ListTile(', 'Material(color: Colors.transparent, child: ListTile(')

# Wait, the replacement adds a Material but it won't add the closing parenthesis for Material!
