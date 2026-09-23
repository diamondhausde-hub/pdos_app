import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I need to add back import of ActivityLogModel
if "import '../models/activity_log_model.dart';" not in content:
    content = "import '../models/activity_log_model.dart';\n" + content

# Revert logsProvider
old_logs_prov = '''final logsProvider = FutureProvider.autoDispose.family<List<BrandActivityLogModel>, String?>((ref, brandId) {
  return ref.watch(logRepositoryProvider).getLogs(brandId: brandId);
});'''
new_logs_prov = '''final logsProvider = FutureProvider.autoDispose.family<List<ActivityLogModel>, String?>((ref, brandId) {
  return ref.watch(logRepositoryProvider).getLogs(brandId: brandId);
});'''
content = content.replace(old_logs_prov, new_logs_prov)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("data_providers fixed")
