import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\task_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace("'/tasks/'", "'/tasks/$id'")
content = content.replace("'Bearer '", "'Bearer $token'")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("task_repository fixed properly")
