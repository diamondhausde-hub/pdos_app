import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace the end of the build method for _AddTaskSheet
content = content.replace('''              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {''', '''              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> _save() async {''')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed missing parenthesis")
