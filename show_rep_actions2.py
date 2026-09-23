import codecs
import re

with codecs.open('lib/features/rep/screens/rep_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

match = re.search(r'actions: \[(.*?)\],\s*body:', text, re.DOTALL)
if match:
    # Just print the last 30 lines of the match
    lines = match.group(1).split('\n')
    print('\n'.join(lines[-30:]))
else:
    print("Not found")
