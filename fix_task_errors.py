import sys

# 1. Add import and change DropdownButtonFormField to DropdownButton
file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import 'package:go_router/go_router.dart';", "import 'package:go_router/go_router.dart';\nimport '../../../core/providers/brand_provider.dart';")
content = content.replace("DropdownButtonFormField<String>(", "DropdownButton<String>(\n              isExpanded: true,")
content = content.replace("initialValue: _taskType,", "value: _taskType,")
content = content.replace("decoration: const InputDecoration(labelText: ", "hint: const Text(")
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

# 2. Add deleteTask to TaskRepository
repo_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\task_repository.dart'
with open(repo_path, 'r', encoding='utf-8') as f:
    repo_content = f.read()

if "Future<void> deleteTask(String id) async" not in repo_content:
    delete_func = '''
  Future<void> deleteTask(String id) async {
    final token = await _api.storage.read(key: 'jwt_token');
    final response = await _api.dio.delete(
      '/tasks/',
      options: Options(headers: {'Authorization': 'Bearer '}),
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
'''
    repo_content = repo_content.replace("Future<List<SupervisorTask>> getTasks(", delete_func + "\n  Future<List<SupervisorTask>> getTasks(")
    with open(repo_path, 'w', encoding='utf-8') as f:
        f.write(repo_content)

print("Fixed task_assignment imports and repo")
