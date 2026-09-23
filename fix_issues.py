import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix TextField hint back to decoration
content = content.replace("TextField(\n                controller: _targetCtrl,\n                hint: const Text(", "TextField(\n                controller: _targetCtrl,\n                decoration: const InputDecoration(labelText: ")
content = content.replace("TextField(\n                controller: _noteCtrl,\n                hint: const Text(", "TextField(\n                controller: _noteCtrl,\n                decoration: const InputDecoration(labelText: ")
content = content.replace("TextField(\n                controller: _productCtrl,\n                hint: const Text(", "TextField(\n                controller: _productCtrl,\n                decoration: const InputDecoration(labelText: ")
content = content.replace("TextField(\n                controller: _qtyCtrl,\n                keyboardType: TextInputType.number,\n                hint: const Text(", "TextField(\n                controller: _qtyCtrl,\n                keyboardType: TextInputType.number,\n                decoration: const InputDecoration(labelText: ")
content = content.replace("TextField(\n                  controller: _targetCtrl,\n                  hint: const Text(", "TextField(\n                  controller: _targetCtrl,\n                  decoration: const InputDecoration(labelText: ")
content = content.replace("TextField(\n                  controller: _noteCtrl,\n                  hint: const Text(", "TextField(\n                  controller: _noteCtrl,\n                  decoration: const InputDecoration(labelText: ")

# Fix missing import for brandsProvider
if "import '../../../core/providers/brand_provider.dart';" not in content:
    content = content.replace("import 'package:go_router/go_router.dart';", "import 'package:go_router/go_router.dart';\nimport '../../../core/providers/brand_provider.dart';")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

# Fix TaskRepository
repo_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\task_repository.dart'
with open(repo_path, 'r', encoding='utf-8') as f:
    repo = f.read()

repo = repo.replace("import 'package:dio/dio.dart';", "") # remove just in case
repo = repo.replace("import '../services/api_service.dart';", "import '../services/api_service.dart';\nimport 'package:dio/dio.dart';")
repo = repo.replace("_api.", "ApiService.instance.")

with open(repo_path, 'w', encoding='utf-8') as f:
    f.write(repo)
print("Fixed issues")
