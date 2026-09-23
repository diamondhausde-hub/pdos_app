with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

# I need to change NavBarItemData for supervisor
# Icons.map_rounded -> "Map" (since we don't have AppStrings.map, I will use literal or check if it exists)
content = content.replace("NavBarItemData(icon: Icons.map_rounded, label: AppStrings.lbl_41)", "NavBarItemData(icon: Icons.map_rounded, label: 'Map')")
content = content.replace("NavBarItemData(icon: Icons.groups_rounded, label: AppStrings.reps)", "NavBarItemData(icon: Icons.groups_rounded, label: 'Team')")
# Wait, AppStrings.reps is probably "Reps". AppStrings.review is probably "Review". That's fine.

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
