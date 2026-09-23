import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\rep_tasks_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add a closing parenthesis before the final two lines of the build method
# The end of the build method is:
#         ],
#       ),
#     );
#   }

content = content.replace('''        ],
      ),
    );
  }

  Widget _buildDetailRow''', '''        ],
      ),
    ));
  }

  Widget _buildDetailRow''')

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed rep_tasks_tab.dart")
