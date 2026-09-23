with open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

new_lines = []
for line in lines:
    line = line.strip()
    if line:
        new_lines.append(line)

with open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(new_lines))
