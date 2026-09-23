import re

log_file = r"C:\Users\prote\.gemini\antigravity\brain\676dc3f9-acef-467f-99f1-5a2686ef33c2\.system_generated\tasks\task-3746.log"

with open(log_file, "r", encoding="utf-8") as f:
    log_content = f.read()

missing_members = set(re.findall(r"Error: Member not found: '([^']+)'", log_content))

new_declarations = []
for member in missing_members:
    # Generate a sensible default string from the camelCase member name
    # e.g. 'noItemsOrdered' -> 'No Items Ordered'
    words = re.sub(r"([A-Z])", r" \1", member).strip()
    words = words[0].upper() + words[1:]
    new_declarations.append(f"  static const String {member} = '{words}';")

if new_declarations:
    with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
        content = f.read()
    
    # insert before the last brace
    insertion = "\n".join(new_declarations) + "\n"
    content = content.replace("}", insertion + "}")
    
    with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
        f.write(content)
    
    print(f"Added {len(missing_members)} missing strings!")
else:
    print("No missing members found in log.")
