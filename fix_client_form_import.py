import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\shared\screens\client_form_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("import '../../../core/providers/auth_provider.dart';", "import '../../../core/providers/auth_provider.dart';\nimport '../../../core/providers/brand_provider.dart';")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Added import to client_form_screen.dart")
