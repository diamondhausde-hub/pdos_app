import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    text = f.read()

old_tile = '''                    Text(
                      "المندوب: ",
                      style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, hh:mm a').format(visit.visitDate.toLocal()),
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                    ),'''

new_tile = '''                    Text(
                      "المندوب: \ - \",
                      style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, hh:mm a').format(visit.visitDate.toLocal()),
                      style: AppTextStyles.labelSm.copyWith(color: AppColors.onSurfaceVariant),
                    ),'''

# It might still be corrupted in the file if make_home.py wrote corrupted bytes.
# Let's just find the exact block and replace it.

import re
text = re.sub(
    r'Text\([^,]+,\s*style: AppTextStyles\.labelMd\.copyWith\(fontWeight: FontWeight\.bold\),\s*\),\s*const SizedBox\(height: 4\),\s*Text\([^,]+format\(visit\.visitDate\.toLocal\(\)\),\s*style: AppTextStyles\.labelSm\.copyWith\(color: AppColors\.onSurfaceVariant\),\s*\),',
    new_tile,
    text
)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(text)
