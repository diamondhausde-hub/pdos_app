import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    lines = f.readlines()

new_lines = []
for i, line in enumerate(lines):
    new_lines.append(line)
    if 'visit.centerName ??' in line:
        if 'style: AppTextStyles.labelMd' in lines[i+1]:
            new_lines.append(lines[i+1])
            new_lines.append('                    maxLines: 1,\n')
            new_lines.append('                    overflow: TextOverflow.ellipsis,\n')
            lines[i+1] = '' # clear it so we don't duplicate

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(''.join(new_lines))
