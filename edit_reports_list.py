with open('lib/features/rep/screens/field_reports_list_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''Navigator.pushNamed(context, '/rep/submit-report');''', '''context.push('/rep/submit-report');''')
if 'import \'package:go_router/go_router.dart\';' not in text:
    text = text.replace('''import 'package:flutter_riverpod/flutter_riverpod.dart';''', '''import 'package:flutter_riverpod/flutter_riverpod.dart';\nimport 'package:go_router/go_router.dart';''')

with open('lib/features/rep/screens/field_reports_list_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
