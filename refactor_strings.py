import os
import re
import string

directories = [
    "lib/features/auth",
    "lib/features/admin",
    "lib/features/supervisor",
    "lib/features/rep",
    "lib/features/shared",
    "lib/core/widgets"
]

patterns = [
    r"Text\(\s*'([^'\\]*(?:\\.[^'\\]*)*)'",
    r'Text\(\s*"([^"\\]*(?:\\.[^"\\]*)*)"',
    r"(labelText|hintText|label|title|tooltip|subtitle|text)\s*:\s*'([^'\\]*(?:\\.[^'\\]*)*)'",
    r'(labelText|hintText|label|title|tooltip|subtitle|text)\s*:\s*"([^"\\]*(?:\\.[^"\\]*)*)"',
]

extracted_strings = {}
counter = 1

def generate_key(s):
    global counter
    # Remove all punctuation and digits at start
    clean = re.sub(r'[^a-zA-Z0-9]', ' ', s).strip()
    words = clean.split()
    if not words:
        key = f"lbl_{counter}"
        counter += 1
        return key
    
    # camelCase
    key = words[0].lower() + "".join(w.capitalize() for w in words[1:4])
    
    # Ensure it's a valid dart identifier
    if not re.match(r'^[a-zA-Z_$][a-zA-Z0-9_$]*$', key) or key in ['class', 'var', 'final', 'String', 'int', 'true', 'false']:
        key = f"lbl_{key}_{counter}"
    
    # deduplicate
    if key in extracted_strings.values():
        key = f"{key}_{counter}"
        counter += 1
    return key

# First pass: collect
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
                            if len(match.groups()) == 1:
                                string_val = match.group(1)
                            else:
                                string_val = match.group(2)
                                
                            if '$' not in string_val and string_val.strip() != "":
                                if string_val not in extracted_strings:
                                    extracted_strings[string_val] = generate_key(string_val)

# Generate AppStrings class
app_strings_content = "class AppStrings {\n"
for val, key in extracted_strings.items():
    safe_val = val.replace("'", "\\'").replace("\n", "\\n")
    app_strings_content += f"  static String get {key} => '{safe_val}';\n"
app_strings_content += "}\n"

os.makedirs("lib/core/localization", exist_ok=True)
with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(app_strings_content)

# Second pass: replace
for d in directories:
    for root, dirs, files in os.walk(d):
        for f in files:
            if f.endswith(".dart"):
                filepath = os.path.join(root, f)
                with open(filepath, "r", encoding="utf-8") as file:
                    content = file.read()
                
                original_content = content
                
                # We need a safe replace function that doesn't mess up non-UI strings
                for val, key in extracted_strings.items():
                    safe_val_single = "'" + val.replace("'", "\\'") + "'"
                    safe_val_double = '"' + val.replace('"', '\\"') + '"'
                    
                    # Pattern replacements for Text
                    content = content.replace(f"Text({safe_val_single}", f"Text(AppStrings.{key}")
                    content = content.replace(f"Text({safe_val_double}", f"Text(AppStrings.{key}")
                    
                    content = content.replace(f"const Text({safe_val_single}", f"Text(AppStrings.{key}")
                    content = content.replace(f"const Text({safe_val_double}", f"Text(AppStrings.{key}")
                    
                    # Pattern replacements for properties
                    for prop in ['labelText', 'hintText', 'label', 'title', 'tooltip', 'subtitle', 'text']:
                        content = content.replace(f"{prop}: {safe_val_single}", f"{prop}: AppStrings.{key}")
                        content = content.replace(f"{prop}: {safe_val_double}", f"{prop}: AppStrings.{key}")
                
                if content != original_content:
                    # Add import if needed
                    if "import 'package:pdos_app/core/localization/app_strings.dart';" not in content and "import '../../../core/localization/app_strings.dart';" not in content:
                        # Just use absolute import
                        content = "import 'package:pdos_app/core/localization/app_strings.dart';\n" + content
                    
                    with open(filepath, "w", encoding="utf-8") as file:
                        file.write(content)

print(f"Replaced {len(extracted_strings)} strings.")
