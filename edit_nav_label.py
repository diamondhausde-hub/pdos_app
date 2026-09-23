with open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('NavBarItemData(icon: Icons.dashboard_rounded, label: AppStrings.lbl_25)', "NavBarItemData(icon: Icons.dashboard_rounded, label: 'الرئيسية')")

with open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
