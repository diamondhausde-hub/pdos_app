import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix imports
content = content.replace(
'''Color _hexToColor(String? hexString) {
  if (hexString == null || hexString.isEmpty) return Colors.grey;
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

import '../../../models/task_model.dart';
import '../../../core/providers/data_providers.dart';''',
'''import '../../../models/task_model.dart';
import '../../../core/providers/data_providers.dart';

Color _hexToColor(String? hexString) {
  if (hexString == null || hexString.isEmpty) return Colors.grey;
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}'''
)

# Fix nullables
content = content.replace('t.brandId != _selectedBrand', 't?.brandId != _selectedBrand')
content = content.replace('t.repId != _selectedRep', 't?.repId != _selectedRep')
content = content.replace('t.taskType != _selectedType', 't?.taskType != _selectedType')

# Fix withOpacity
content = content.replace('.withOpacity(', '.withValues(alpha: ')

# Fix deprecated value
content = content.replace('value: _taskType,', 'initialValue: _taskType,')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("task_assignment_screen.dart fixed")
