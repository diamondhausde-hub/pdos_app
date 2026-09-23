import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the Container with Material in task_management_screen.dart

old_1 = '''        child: Container(
          margin: EdgeInsets.only(top: kToolbarHeight),
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),'''

new_1 = '''        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            margin: EdgeInsets.only(top: kToolbarHeight),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),'''

old_2 = '''        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),'''

new_2 = '''        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.all(20),'''

content = content.replace(old_1, new_1)
content = content.replace(old_2, new_2)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated task_management_screen.dart")

# Now check rep_tasks_tab.dart
file_path_2 = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\rep_tasks_tab.dart'
with open(file_path_2, 'r', encoding='utf-8') as f:
    content2 = f.read()

old_3 = '''    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),'''

new_3 = '''    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,'''

content2 = content2.replace(old_3, new_3)

with open(file_path_2, 'w', encoding='utf-8') as f:
    f.write(content2)
print("Updated rep_tasks_tab.dart")
