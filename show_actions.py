import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

import re
match = re.search(r'actions: \[.*?\]\s*,', text, re.DOTALL)
if match:
    print(match.group(0))
else:
    print("Not found")
