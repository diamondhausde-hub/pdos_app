with open("lib/features/rep/screens/visit_wizard_screen.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
matches = re.findall(r"'[^']*'", content)
for m in matches:
    if 'U,' in m or 'O1' in m:
        print(m)
