import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\local_db\app_database.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# change schemaVersion from 21 to 22
content = content.replace('int get schemaVersion => 21;', 'int get schemaVersion => 22;')

# Add migration if (from < 22) { await m.addColumn(localClients, localClients.brandId); }
migration_code = '''          if (from < 21) {
              await m.addColumn(localVisits, localVisits.referenceCode);
              await m.addColumn(localAppointments, localAppointments.referenceCode);
              await m.addColumn(localAppointments, localAppointments.status);
            }
          if (from < 22) {
              await m.addColumn(localClients, localClients.brandId);
          }'''
          
content = re.sub(r'if \(from < 21\) \{[\s\S]*?\}', migration_code, content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated schemaVersion and migration in app_database.dart")
