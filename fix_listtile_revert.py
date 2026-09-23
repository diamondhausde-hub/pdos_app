import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add missing closing parenthesis for Padding and Material
# In _AddTaskSheet
# Search for the end of SingleChildScrollView in _AddTaskSheet
# The structure was: 
#      child: Container( ... child: Material( ... child: Padding( ... child: SingleChildScrollView( ... )
# Wait, I just need to replace the Material with Container and BoxDecoration again, 
# and then use a regex to wrap ListTile with Material.

# Let's restore the Container decoration
material1 = '''      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
            child: SingleChildScrollView('''

container1 = '''      child: Container(
        margin: EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView('''
content = content.replace(material1, container1)


material2 = '''      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SingleChildScrollView('''

container2 = '''      child: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView('''

content = content.replace(material2, container2)


# Now wrap ListTiles
content = re.sub(r'(ListTile\([^)]*?\n\s*\))', r'Material(color: Colors.transparent, child: \1)', content)
content = content.replace('return ListTile(', 'return Material(color: Colors.transparent, child: ListTile(')
content = content.replace('ListTile(', 'Material(color: Colors.transparent, child: ListTile(')
# Wait, replacing ListTile( with Material(...ListTile( will cause infinite nesting if I do it blindly.

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Restored task_management_screen.dart")

file_path_2 = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\rep_tasks_tab.dart'
with open(file_path_2, 'r', encoding='utf-8') as f:
    content2 = f.read()

material3 = '''    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column('''
        
container3 = '''    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column('''

content2 = content2.replace(material3, container3)
with open(file_path_2, 'w', encoding='utf-8') as f:
    f.write(content2)

print("Restored rep_tasks_tab.dart")
