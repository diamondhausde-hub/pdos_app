import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\my_day_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix the broken code
broken_code = '''
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.insights_rounded,
                    color: AppColors.secondary,
                    
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.task_alt_rounded,
                    color: AppColors.error,
                    title: 'U.UO U.US',
                    onTap: () {
                      context.push('/rep/tasks');
                    },
                  ),
                title: AppStrings.performance,
                    onTap: () {
                      context.push('/rep/performance');
                    },
                  ),
'''

fixed_code = '''
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
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.insights_rounded,
                    color: AppColors.secondary,
                    title: AppStrings.performance,
                    onTap: () {
                      context.push('/rep/performance');
                    },
                  ),
'''

content = content.replace(broken_code, fixed_code)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed my_day_tab.dart")
