import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    lines = f.readlines()

# find where }); is and _FlaggedVisitsSection is
start = -1
end = -1
for i, line in enumerate(lines):
    if line.strip() == '});':
        start = i
    if 'class _FlaggedVisitsSection extends StatelessWidget' in line:
        end = i
        break

if start != -1 and end != -1:
    del lines[start:end]

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.writelines(lines)
