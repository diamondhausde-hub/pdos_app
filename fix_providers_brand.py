import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

import re

# We need to change clientsStreamProvider to filter by brandId
old_code = '''final clientsStreamProvider = StreamProvider<List<ClientModel>>((ref) {
  final repo = ref.watch(clientRepositoryProvider);
  // Do not filter by repId here. The local database only contains clients 
  // that the current user (rep/supervisor/gm) is authorized to see, 
  // because the backend scoped the sync process.
  return repo.watchClients();
});'''

new_code = '''final clientsStreamProvider = StreamProvider<List<ClientModel>>((ref) {
  final repo = ref.watch(clientRepositoryProvider);
  final brandId = ref.watch(selectedBrandIdProvider);
  return repo.watchClients(brandId: brandId);
});'''

content = content.replace(old_code, new_code)
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("data_providers updated")
