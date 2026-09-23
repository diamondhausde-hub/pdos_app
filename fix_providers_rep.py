import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old = '''final repClientsStreamProvider = StreamProvider.family<List<ClientModel>, String>((ref, repId) {
  final repo = ref.watch(clientRepositoryProvider);
  return repo.watchClients(repId: repId);
});'''
new = '''final repClientsStreamProvider = StreamProvider.family<List<ClientModel>, String>((ref, repId) {
  final repo = ref.watch(clientRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return repo.watchClients(repId: repId, brandId: brandId);
});'''
content = content.replace(old, new)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("repClientsStreamProvider updated")
