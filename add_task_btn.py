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

if 'مهامي' not in content:
    content = content.replace(
        "title: AppStrings.performance,", 
        "title: AppStrings.performance,".replace("title: AppStrings.performance,", task_card + "                title: AppStrings.performance,")
    )

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Added Tasks to my_day_tab")
