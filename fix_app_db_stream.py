import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\local_db\app_database.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("Stream<List<LocalClient>> getClientsStream({String? repId}) {", "Stream<List<LocalClient>> getClientsStream({String? repId, String? brandId}) {")
old_query = '''    if (repId != null) {
      query = query..where((t) => t.repId.equals(repId));
    }
    // Note: brandId filtering will be done in memory for now to avoid breaking existing Drift queries without a full migration, 
    // but ideally it should be a where clause if the column is fully added.'''
new_query = '''    if (repId != null) {
      query = query..where((t) => t.repId.equals(repId));
    }
    if (brandId != null) {
      query = query..where((t) => t.brandId.equals(brandId));
    }'''
content = content.replace(old_query, new_query)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("app_database getClientsStream updated")
