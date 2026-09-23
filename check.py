import codecs
text = codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8').read()
print('Has Expanded:', 'Expanded' in text)
print('Has maxLines:', 'maxLines: 1' in text)
print('Has rawName:', 'rawName.isEmpty' in text)
