import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_management_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# _AddTaskSheet build method
pattern1 = r'child: Container\(\s*margin: EdgeInsets\.only\(top: kToolbarHeight\),\s*padding: EdgeInsets\.fromLTRB\(20, 20, 20, 20 \+ bottomInset\),\s*decoration: BoxDecoration\(\s*color: Theme\.of\(context\)\.scaffoldBackgroundColor,\s*borderRadius: const BorderRadius\.vertical\(top: Radius\.circular\(24\)\),\s*\),'

replacement1 = '''child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            margin: EdgeInsets.only(top: kToolbarHeight),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),'''
            
content = re.sub(pattern1, replacement1, content)

# Need to add a closing parenthesis for _AddTaskSheet
content = content.replace('''        ),
      ),
    );

    if (confirm == true) {''', '''        ),
      )),
    );

    if (confirm == true) {''')

# _TaskDetailsSheet build method
pattern2 = r'child: Container\(\s*height: MediaQuery\.of\(context\)\.size\.height \* 0\.85,\s*padding: const EdgeInsets\.all\(20\),\s*decoration: BoxDecoration\(\s*color: Theme\.of\(context\)\.scaffoldBackgroundColor,\s*borderRadius: const BorderRadius\.vertical\(top: Radius\.circular\(24\)\),\s*\),'

replacement2 = '''child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            padding: const EdgeInsets.all(20),'''
            
content = re.sub(pattern2, replacement2, content)

# Need to add a closing parenthesis for _TaskDetailsSheet
# End of _TaskDetailsSheet:
#       ),
#     );
#   }
# }

content = content.replace('''        ),
      ),
    );
  }
}''', '''        ),
      )),
    );
  }
}''')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Regex replaced in task_management_screen.dart")
