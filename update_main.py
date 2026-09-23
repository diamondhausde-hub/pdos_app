with open("lib/main.dart", "r", encoding="utf-8") as f:
    content = f.read()

import_statement = "import 'package:flutter_localizations/flutter_localizations.dart';\nimport 'package:flutter_gen/gen_l10n/app_localizations.dart';\n"
if "flutter_localizations" not in content:
    content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\n" + import_statement)

# Add localizationsDelegates and supportedLocales to MaterialApp.router
if "localizationsDelegates:" not in content:
    replacement = """      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,"""
    content = content.replace("      themeMode: themeMode,", replacement)

with open("lib/main.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Updated main.dart")
