import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\local_db\app_database.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("TextColumn get repId => text()();", "TextColumn get repId => text()();\n  TextColumn get brandId => text().nullable()();")
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("app_database.dart updated")
