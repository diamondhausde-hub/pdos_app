import sys

# 1. Update models.py
models_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\models.py'
with open(models_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("client_type = Column(String, default=\"doctor\")", "brand_id = Column(String, ForeignKey('brands.id'), nullable=True)\n    client_type = Column(String, default=\"doctor\")")
with open(models_path, 'w', encoding='utf-8') as f:
    f.write(content)

# 2. Update schemas.py
schemas_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\schemas.py'
with open(schemas_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("client_type: Optional[str] = \"doctor\"", "brand_id: Optional[str] = None\n    client_type: Optional[str] = \"doctor\"")
with open(schemas_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("models and schemas updated.")
