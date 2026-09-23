import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

old_1 = '''      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),'''

new_1 = '''      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),'''

content = content.replace(old_1, new_1)

# Oh wait, we need to add a closing parenthesis at the end of _AddTaskSheet if we wrap it in a Material!
# Let's see how it ends.
old_end = '''              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskDetailsSheet extends StatefulWidget {'''

new_end = '''              ),
            ],
          ),
        ),
      )),
    );
  }
}

class _TaskDetailsSheet extends StatefulWidget {'''

content = content.replace(old_end, new_end)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed _AddTaskSheet")
