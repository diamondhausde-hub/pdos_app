import codecs
with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

text = text.replace("import '../../../core/providers/auth_provider.dart';\n", '')
text = text.replace("import '../../../core/providers/auth_provider.dart';\r\n", '')

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
