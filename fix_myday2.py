import re

file_path = r'C:\Users\prot\Documents\PDOS\pdos_app\lib\features\rep\screens\my_day_tab.dart'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# I will find the first Wrap children array
start = content.find('children: [')
end = content.find('],', start)

correct_children = '''children: [
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.primary,
                    title: AppStrings.expenses,
                    onTap: () {
                      context.push('/rep/expenses');
                    },
                  ),
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
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.history_rounded,
                    color: AppColors.tertiary,
                    title: AppStrings.visitHistory,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VisitHistoryScreen()));
                    },
                  ),
                _buildActionCard(
                    context: context,
                    width: cardWidth,
                    icon: Icons.medication_rounded,
                    color: AppColors.info,
                    title: AppStrings.products,
                    onTap: () => context.push('/rep/products'),
                  ),
              ]'''

content = content[:start] + correct_children + content[end+1:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed my_day_tab.dart")
