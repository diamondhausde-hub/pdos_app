import re

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\routers\tasks_router.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacement = '''    db_task = models.Task(**task.dict())
    if not db_task.supervisor_id:
        db_task.supervisor_id = current_user.id
    if not db_task.brand_id:
        db_task.brand_id = current_user.brand_id'''

content = content.replace('    db_task = models.Task(**task.dict())\n    if not db_task.supervisor_id:\n        db_task.supervisor_id = current_user.id', replacement)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Set brand_id fallback in tasks_router")
