with open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("import '../../../core/providers/data_providers.dart';", "import '../../../core/providers/data_providers.dart';\nimport '../../../core/providers/auth_provider.dart';")
text = text.replace("value: \"\\\\\\\$\K\",", "value: \"\\$\K\",")
text = text.replace(".withOpacity(", ".withValues(alpha: ")
text = text.replace("const Icon(Icons.check_circle_outline_rounded", "Icon(Icons.check_circle_outline_rounded")
text = text.replace("const Text(\n                      \"لا توجد", "Text(\n                      \"لا توجد")

with open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
