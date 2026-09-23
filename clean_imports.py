with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

imports_to_remove = [
    "import 'expenses_tab.dart';",
    "import 'products_tab.dart';",
    "import 'rep_performance_tab.dart';",
    "import '../../supervisor/screens/coverage_map_tab.dart';"
]

for imp in imports_to_remove:
    content = content.replace(imp + "\n", "")

with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Cleaned up unused imports")
