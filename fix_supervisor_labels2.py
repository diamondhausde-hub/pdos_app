with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("label: 'Map'", "label: AppStrings.lbl_25")
content = content.replace("label: 'Team'", "label: AppStrings.lbl_26")

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
