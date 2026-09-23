with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    lines = f.readlines()

for line in lines:
    if "static const String lbl_" in line:
        print(line.strip())
