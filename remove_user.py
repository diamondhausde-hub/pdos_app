import codecs
with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

text = text.replace('    final user = ref.watch(currentUserProvider);\n', '')
text = text.replace('    final user = ref.watch(currentUserProvider);\r\n', '')

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
