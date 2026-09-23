import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\main.py'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

if 'from routers import tasks_router' not in content:
    content = content.replace('from routers import admin_router', 'from routers import admin_router\nfrom routers import tasks_router')
    content = content.replace('app.include_router(admin_router.router)', 'app.include_router(admin_router.router)\napp.include_router(tasks_router.router)')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print('main.py updated')
