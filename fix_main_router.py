import sys

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\main.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("from routers.chat_router import router as chat_router", "from routers.chat_router import router as chat_router\nfrom routers.tasks_router import router as tasks_router")
content = content.replace("app.include_router(chat_router)", "app.include_router(chat_router)\napp.include_router(tasks_router)")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("main.py updated")
