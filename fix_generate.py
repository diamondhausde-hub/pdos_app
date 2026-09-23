with open("pubspec.yaml", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("flutter:\n  uses-material-design: true", "flutter:\n  generate: true\n  uses-material-design: true")
if "generate: true" not in content:
    content = content.replace("flutter:\n", "flutter:\n  generate: true\n")

with open("pubspec.yaml", "w", encoding="utf-8") as f:
    f.write(content)
