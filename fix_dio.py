import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\repositories\task_repository.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace(r"'/tasks/\'", r"'/tasks/'")
content = content.replace(r"'/tasks/\'", r"'/tasks/'")
content = content.replace(r"'/tasks/\/history'", r"'/tasks//history'")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed variables in task_repository.dart")
