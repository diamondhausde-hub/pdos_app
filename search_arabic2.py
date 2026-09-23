with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if "المواعيد" in line:
        print(f"Line {i+1}: {line.strip()}")
