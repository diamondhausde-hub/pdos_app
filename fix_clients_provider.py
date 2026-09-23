import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Change clientsStreamProvider to not filter by user?.id
old_prov = '''final clientsStreamProvider = StreamProvider<List<ClientModel>>((ref) {
  final repo = ref.watch(clientRepositoryProvider);
  final user = ref.watch(currentUserProvider);
  return repo.watchClients(repId: user?.id);
});'''
new_prov = '''final clientsStreamProvider = StreamProvider<List<ClientModel>>((ref) {
  final repo = ref.watch(clientRepositoryProvider);
  // Do not filter by repId here. The local database only contains clients 
  // that the current user (rep/supervisor/gm) is authorized to see, 
  // because the backend scoped the sync process.
  return repo.watchClients();
});'''

content = content.replace(old_prov, new_prov)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("clientsStreamProvider updated")
