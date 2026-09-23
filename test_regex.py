with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
matches = re.findall(r"title: '.*?',\s*subtitle: '.*?'", content)
print(matches)
