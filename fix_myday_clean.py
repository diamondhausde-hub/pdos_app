import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\my_day_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

task_card = '''
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.task_alt_rounded,
                    color: AppColors.error,
                    title: 'مهامي',
                    onTap: () {
                      context.push('/rep/tasks');
                    },
                  ),
'''

# Find title: AppStrings.performance and insert task_card before its _buildActionCard
idx = content.find("title: AppStrings.performance,")
if idx != -1:
    # Find the _buildActionCard before this
    start_idx = content.rfind('_buildActionCard', 0, idx)
    content = content[:start_idx] + task_card + content[start_idx:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Added Tasks to my_day_tab properly")
