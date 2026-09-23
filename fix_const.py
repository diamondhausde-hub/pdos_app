with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("const _ScreenWrapper(", "_ScreenWrapper(")

with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Removed const from _ScreenWrapper")
