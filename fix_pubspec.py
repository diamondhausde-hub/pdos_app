with open("pubspec.yaml", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("  flutter:\n  generate: true\n    sdk: flutter", "  flutter:\n    sdk: flutter")
if "generate: true" not in content:
    content = content.replace("\nflutter:\n", "\nflutter:\n  generate: true\n")

with open("pubspec.yaml", "w", encoding="utf-8") as f:
    f.write(content)
