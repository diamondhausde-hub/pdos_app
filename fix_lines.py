import sys

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\supervisor\screens\task_assignment_screen.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

replacement = '''                                      Expanded(
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
                                      ),
'''

new_lines = lines[:374] + [replacement] + lines[381:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.writelines(new_lines)
print("Lines replaced")
