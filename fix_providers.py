import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

tasks_provider_code = '''
final tasksProvider = FutureProvider.autoDispose<List<SupervisorTask>>((ref) async {
  final brandId = ref.watch(selectedBrandIdProvider);
  return ref.watch(taskRepositoryProvider).getTasks(brandId: brandId);
});

final myTasksProvider = FutureProvider.autoDispose<List<SupervisorTask>>((ref) async {
  return ref.watch(taskRepositoryProvider).getTasks();
});

final taskHistoryProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, taskId) async {
  return ref.watch(taskRepositoryProvider).getTaskHistory(taskId);
});
'''

# Find tasksProvider and replace with the new code
content = re.sub(r'final tasksProvider = FutureProvider\.autoDispose<List<SupervisorTask>>\(\(ref\) async \{[\s\S]*?\}\);', tasks_provider_code, content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated data_providers.dart")
