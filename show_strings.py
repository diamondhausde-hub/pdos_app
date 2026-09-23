import codecs
text = codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8').read()
import re
print(re.findall(r'\"([^\"]+)\"', text))
