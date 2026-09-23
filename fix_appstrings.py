with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace(r"\\'", r"\'")

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
