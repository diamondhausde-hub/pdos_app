
import codecs
import re

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

# Fix Brand Switcher
content = content.replace("Text('OU.USO1 O U,O\"OO U+O_O O')", "Text('جميع البراندات')")
content = content.replace("Text(b.name ?? 'O\"OO U+O_')", "Text(b.name ?? 'براند')")

# Fix Targets overview if messed up
content = content.replace("Text('OrOO U?US O U,OO-U.USU,')", "Text('خطأ في التحميل')")
content = content.replace("Text(\"U,O  OU^OO_ OUO_O U? O-O U,USO U<\")", "Text('لا توجد أهداف حالياً')")
content = content.replace("Text('U,O  OU^OO_ OUO_O U? O-O U,USO U<')", "Text('لا توجد أهداف حالياً')")

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

