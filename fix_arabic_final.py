import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if 'const DropdownMenuItem(value: null' in line:
        lines[i] = "            const DropdownMenuItem(value: null, child: Text('جميع البراندات')),\n"
    elif "Text('OrO" in line:
        lines[i] = "          error: (e, s) => const Text('خطأ في التحميل'),\n"
    elif 'child: const Center(child: Text("U,O  O' in line:
        lines[i] = '                  child: const Center(child: Text("لا توجد أهداف حالياً")),\n'

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.writelines(lines)
