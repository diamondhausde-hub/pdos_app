with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    lines = f.readlines()

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    for line in lines:
        if "styleApptextstylesBodysmCopywith" not in line and "AppColors.onSurface" not in line and "});" not in line and "])" not in line and "Expanded(child" not in line:
            f.write(line)
