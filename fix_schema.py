import re

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\schemas.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('    brand_id: str\n', '    brand_id: Optional[str] = None\n')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Made brand_id optional in schemas")
