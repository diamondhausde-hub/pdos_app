
import codecs
with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

# Just put the literal string back exactly
content = content.replace("value: \"$${(analytics.totalRevenue", "value: \"\\$${(analytics.totalRevenue")

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

