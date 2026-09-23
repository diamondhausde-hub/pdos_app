with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant", "Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceVariant")

with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
