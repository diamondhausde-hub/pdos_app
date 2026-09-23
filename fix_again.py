import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Make sure brand_provider is imported
if "brand_provider.dart" not in content:
    content = content.replace("import '../../../core/models/task_model.dart';", "import '../../../core/models/task_model.dart';\nimport '../../../core/providers/brand_provider.dart';")

# Fix any remaining hint: const Text in TextField
import re
content = re.sub(r'TextField\(\s*controller:\s*_targetCtrl,\s*hint:\s*const Text\(', r'TextField(\n                controller: _targetCtrl,\n                decoration: const InputDecoration(labelText: ', content)
content = re.sub(r'TextField\(\s*controller:\s*_noteCtrl,\s*hint:\s*const Text\(', r'TextField(\n                controller: _noteCtrl,\n                decoration: const InputDecoration(labelText: ', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed again")
