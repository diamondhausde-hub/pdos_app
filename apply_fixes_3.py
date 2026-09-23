import codecs
with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    text = f.read()

text = text.replace('\r\n', '\n')

old_str = '''                  Text(
                    "المركز: ",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                  ),'''
new_str = '''                  Text(
                    "المركز: ",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),'''

text = text.replace(old_str, new_str)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(text)
