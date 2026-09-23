import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\shared\screens\client_form_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("repId: user.id,", "repId: user.id,\n        brandId: ref.read(selectedBrandIdProvider),")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("ClientFormScreen updated")
