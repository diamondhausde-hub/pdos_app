import sys
import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# The pattern is:
# Row(
#   children: [
#     Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
#     const SizedBox(width: 4),
#     Text(task.repName ?? '', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
#   ],
# ),

pattern = re.compile(r'Row\(\s*children:\s*\[\s*Icon\(Icons\.person_outline[^\]]+\]\s*,\s*\)', re.MULTILINE)

new_rep_row = '''Expanded(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Icon(Icons.person_outline, size: 14, color: Colors.grey[600]),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          task.repName ?? '', 
          style: TextStyle(fontSize: 12, color: Colors.grey[700]), 
          maxLines: 1, 
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  ),
)'''

content, count = pattern.subn(new_rep_row, content)
print(f"Replaced {count} occurrences")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

