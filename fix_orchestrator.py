import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\core\providers\data_providers.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

import re
old_code = '''getRepId: () => ref.read(currentUserProvider)?.id,'''
new_code = '''getRepId: () {
        final user = ref.read(currentUserProvider);
        if (user == null) return null;
        if (user.role == UserRole.rep) return user.id;
        // Supervisors and GMs should pull all data in their scope, not just their own
        return null;
      },'''

content = content.replace(old_code, new_code)
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("SyncOrchestrator updated")
