with open("lib/features/shared/screens/profile_screen.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
matches = re.findall(r"'[^']*'", content)
for m in matches:
    print(m)
