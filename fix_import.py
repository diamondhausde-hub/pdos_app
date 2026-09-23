with open("lib/main.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("import 'package:flutter_gen/gen_l10n/app_localizations.dart';\n", "")

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(content)
