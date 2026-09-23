import os
import re
import json

directories = [
    "lib/features/auth",
    "lib/features/admin",
    "lib/features/supervisor",
    "lib/features/rep",
    "lib/features/shared",
    "lib/core/widgets"
]

# Regex to match strings in specific UI patterns. 
# We'll look for Text('...') or Text("...") 
# Also labelText: '...', hintText: '...', label: '...', title: '...', tooltip: '...'
patterns = [
    r"Text\(\s*'([^'\\]*(?:\\.[^'\\]*)*)'",
    r'Text\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"',
    r"(?:labelText|hintText|label|title|tooltip|subtitle|text)\s*:\s*'([^'\\]*(?:\\.[^'\\]*)*)'",
    r'(?:labelText|hintText|label|title|tooltip|subtitle|text)\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"',
]

extracted_strings = set()
string_locations = []

for d in directories:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith(".dart"):
                filepath = os.path.join(root, f)
                with open(filepath, "r", encoding="utf-8") as file:
                    content = file.read()
                    for p in patterns:
                        matches = re.finditer(p, content)
                        for match in matches:
                            string_val = match.group(1)
                            # Skip strings with interpolation $ 
                            if '$' not in string_val and string_val.strip() != "":
                                extracted_strings.add(string_val)
                                string_locations.append({
                                    "file": filepath,
                                    "string": string_val
                                })

with open("extracted_strings.json", "w", encoding="utf-8") as f:
    json.dump(list(extracted_strings), f, ensure_ascii=False, indent=2)

print(f"Extracted {len(extracted_strings)} unique strings.")
