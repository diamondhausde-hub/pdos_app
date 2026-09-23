
import codecs
with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

content = content.replace("context.push('/clients/new')", "context.push('/clients/new?type=doctor')")
content = content.replace("context.push('/centers/new')", "context.push('/clients/new?type=pharmacy')")

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

