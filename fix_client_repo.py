import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\client_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("Stream<List<ClientModel>> watchClients({String? repId}) {", "Stream<List<ClientModel>> watchClients({String? repId, String? brandId}) {")
content = content.replace("return _localDb.getClientsStream(repId: repId).map(", "return _localDb.getClientsStream(repId: repId, brandId: brandId).map(")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("client_repository updated")
