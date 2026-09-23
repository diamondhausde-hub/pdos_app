import re

with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

matches = re.findall(r"static const String ([a-zA-Z0-9_$]+) = '([^']+)';", content)

with open("arabic_keys_left.txt", "w", encoding="utf-8") as out:
    for key, val in matches:
        if re.search(r'[\u0600-\u06FF]', val) or 'U,' in val or 'O' in val or 'U.' in val:
            out.write(f"{key}: {val}\n")
