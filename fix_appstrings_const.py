with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
# Replace `static String get xxx => 'yyy';` with `static const String xxx = 'yyy';`
content = re.sub(r"static String get ([a-zA-Z0-9_$]+) =>", r"static const String \1 =", content)

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
