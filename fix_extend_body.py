with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()
content = content.replace("extendBody: true,", "extendBody: false,")
with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)

with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content2 = f.read()
content2 = content2.replace("extendBody: true,", "extendBody: false,")
with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content2)
