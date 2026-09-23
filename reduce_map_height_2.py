with open("lib/features/rep/screens/my_day_tab.dart", "r", encoding="utf-8") as f:
    content = f.read()

search_str = """        // Ensure Stack has a minimum height if constraints are unbounded
        SizedBox(
          height: MediaQuery.of(context).size.height - 160,
          width: double.infinity,
        ),"""

replace_str = """        // Ensure Stack has a minimum height if constraints are unbounded
        SizedBox(
          height: MediaQuery.of(context).size.height - 140,
          width: double.infinity,
        ),"""

content = content.replace(search_str, replace_str)

with open("lib/features/rep/screens/my_day_tab.dart", "w", encoding="utf-8") as f:
    f.write(content)
