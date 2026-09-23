import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will just replace the BoxDecoration with Material by doing string replacement on the container.

container1 = '''      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView('''

material1 = '''      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
            child: SingleChildScrollView('''

content = content.replace(container1, material1)

container2 = '''      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView('''

material2 = '''      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SingleChildScrollView('''

content = content.replace(container2, material2)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed task_management_screen.dart")

file_path_2 = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\rep_tasks_tab.dart'
with open(file_path_2, 'r', encoding='utf-8') as f:
    content2 = f.read()

container3 = '''    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column('''

material3 = '''    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column('''

content2 = content2.replace(container3, material3)

with open(file_path_2, 'w', encoding='utf-8') as f:
    f.write(content2)

print("Fixed rep_tasks_tab.dart")
