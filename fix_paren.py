with open('lib/features/supervisor/screens/supervisor_home.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('                (,\n', '                ),\n')
with open('lib/features/supervisor/screens/supervisor_home.dart', 'w', encoding='utf-8') as f:
    f.write(text)

with open('lib/features/supervisor/screens/test_home.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('                (,\n', '                ),\n')
with open('lib/features/supervisor/screens/test_home.dart', 'w', encoding='utf-8') as f:
    f.write(text)

