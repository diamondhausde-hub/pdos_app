file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\task_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('/tasks/\\$taskId', '/tasks/$taskId')
content = content.replace('/tasks/\\$id', '/tasks/$id')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Replaced successfully")
