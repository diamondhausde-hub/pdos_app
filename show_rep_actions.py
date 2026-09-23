import codecs
import re

with codecs.open('lib/features/rep/screens/rep_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

match = re.search(r'actions: \[.*?\]\s*,', text, re.DOTALL)
if match:
    print(match.group(0))
else:
    print("Not found")
