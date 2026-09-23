with open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('NavBarItemData(icon: Icons.map_rounded', 'NavBarItemData(icon: Icons.dashboard_rounded')

with open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
