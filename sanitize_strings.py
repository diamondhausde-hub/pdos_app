import re

with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

# Find the valid AppStrings class definition
match = re.search(r'class AppStrings \{.*?(?=^\})\}', content, re.MULTILINE | re.DOTALL)
if match:
    # Just extract the static const properties
    inner = match.group(0)
    lines = inner.split("\n")
    valid_lines = [l for l in lines if "static const String" in l or "class AppStrings" in l or l.strip() == "}"]
    
    # ensure closing brace
    if "}" not in valid_lines[-1]:
        valid_lines.append("}")
        
    final_content = "\n".join(valid_lines)
    with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
        f.write(final_content)
    print("app_strings.dart successfully sanitized")
else:
    print("Could not find AppStrings class")
