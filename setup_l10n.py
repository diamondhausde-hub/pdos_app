import os

l10n_yaml = """arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart"""

with open("l10n.yaml", "w", encoding="utf-8") as f:
    f.write(l10n_yaml)

os.makedirs("lib/l10n", exist_ok=True)

app_en = """{
  "@@locale": "en",
  "appName": "PDOS App",
  "@appName": {
    "description": "The name of the application"
  }
}"""

with open("lib/l10n/app_en.arb", "w", encoding="utf-8") as f:
    f.write(app_en)
