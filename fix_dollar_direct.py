
import codecs
with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

content = content.replace(r"\${", "${")
content = content.replace(r"\$", "$")
content = content.replace("value: \"${(analytics.totalRevenue", "value: \"\$${(analytics.totalRevenue")

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

