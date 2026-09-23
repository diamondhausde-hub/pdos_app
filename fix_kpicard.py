import codecs
import re

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    text = f.read()

# Replace _KpiCard
# Find class _KpiCard and grab it entirely up to the next class or end of file
old_kpi_card = re.search(r'class _KpiCard extends StatelessWidget \{.*?\n\s*\}\n\s*\}', text, re.DOTALL)
if old_kpi_card:
    new_kpi_card = '''class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.labelMd.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.headlineSm.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: color.withValues(alpha: 0.1),
            color: color,
            borderRadius: BorderRadius.circular(4),
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}'''
    text = text.replace(old_kpi_card.group(0), new_kpi_card)
    print("Replaced KpiCard")

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(text)
