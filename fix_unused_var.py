with open("lib/features/rep/screens/my_day_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

content = content.replace("final isDark = Theme.of(context).brightness == Brightness.dark;\n\n    return coverageAsync.when(", "return coverageAsync.when(")

with open("lib/features/rep/screens/my_day_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
