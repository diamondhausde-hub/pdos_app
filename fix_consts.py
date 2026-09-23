import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace 'const Text(' with 'Text(' if it's followed by 'style: AppTextStyles'
content = re.sub(r'const\s+Text\(([^)]*?style:\s*AppTextStyles\.[^)]*?)\)', r'Text(\1)', content)

# Also check for other invalid consts with AppTextStyles
# e.g., 'const TextStyle' shouldn't be here but wait, AppTextStyles is a getter.

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Removed invalid consts")
