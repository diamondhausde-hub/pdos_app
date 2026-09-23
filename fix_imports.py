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

# Fix deprecated withOpacity
content = content.replace('.withOpacity(', '.withValues(alpha: ')

# Fix deprecated DropdownButtonFormField 'value:' -> 'initialValue:'
# Wait, DropdownButtonFormField uses alue, not initialValue. The deprecation error says:
# "value is deprecated and shouldn't be used. Use initialValue instead. This feature was deprecated after v3.33.0-1.0.pre."
# Wait, for DropdownMenu? Or DropdownButtonFormField? Let's check what it is.
