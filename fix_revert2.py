import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the AlertDialog
bad_dialog = '''          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('OU,OO O')),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('O-OU?', style: TextStyle(color: Colors.red))),
          ],
        ),
      )),
    );

    if (confirm == true) {'''

good_dialog = bad_dialog.replace(')),', '),')

content = content.replace(bad_dialog, good_dialog)

# And fix line 757, which is probably the end of _TaskDetailsSheet
#     )),
#   );
# }
# }
bad_end = '''        ),
      )),
    );
  }
}'''
good_end = '''        ),
      ),
    );
  }
}'''
content = content.replace(bad_end, good_end)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Reverted bad changes")
