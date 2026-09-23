with open("pubspec.yaml", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("intl: ^0.20.3", "intl: ^0.20.2")

with open("pubspec.yaml", "w", encoding="utf-8") as f:
    f.write(content)
