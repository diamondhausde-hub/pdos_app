import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

start = content.find('Future<void> _updateStatus(String newStatus) async {')
end = content.find('Widget _buildStatusButton', start)

print(content[start:end])
