import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will find '      )),\n    );\n\n    if (confirm == true) {' and replace it with '      ),\n    );\n\n    if (confirm == true) {'
content = content.replace('      )),\n    );\n\n    if (confirm == true) {', '      ),\n    );\n\n    if (confirm == true) {')
content = content.replace('        ),\n      )),\n    );\n  }\n}', '        ),\n      ),\n    );\n  }\n}')

# I also need to fix 534:
content = content.replace('''          ),
        ),
      )),
    );
  }
}

class _TaskDetailsSheet extends StatefulWidget {''', '''          ),
        ),
      ),
    );
  }
}

class _TaskDetailsSheet extends StatefulWidget {''')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Fixed parens")
