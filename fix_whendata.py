import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\rep_tasks_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace tasksAsync.whenData(...).valueOrNull ?? const SizedBox()
# with tasksAsync.maybeWhen(data: (tasks) { ... }, orElse: () => const SizedBox())
content = re.sub(
    r'tasksAsync\.whenData\(\(tasks\) \{([\s\S]*?)\}\)\.valueOrNull \?\? const SizedBox\(\)',
    r'tasksAsync.maybeWhen(data: (tasks) {\1}, orElse: () => const SizedBox())',
    content
)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed whenData in rep_tasks_tab")
