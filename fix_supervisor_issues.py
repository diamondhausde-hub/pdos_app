with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant", "Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant")

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)

with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    strings_content = f.read()

if "static const String inventory =" not in strings_content:
    strings_content = strings_content.replace("}", "  static const String inventory = 'Inventory';\n}")
    with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
        f.write(strings_content)
