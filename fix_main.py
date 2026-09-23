import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\main.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'from routers.tasks_router import router as tasks_router' not in content:
    # Let's see how routers are imported
    pass

