import codecs
with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    content = f.read()

content = content.replace("value: \"\\\$", "value: \"\$")
content = content.replace("import '../../rep/screens/my_day_tab.dart' hide MyDayTab;\n", "")

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(content)
