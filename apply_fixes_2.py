import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    text = f.read()

# Try again with a softer replacement
text = text.replace('''                  Text(
                    "المركز: ",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                  ),''', '''                  Text(
                    "المركز: ",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),''')

# Wait, the line endings might be CRLF. Let's do a regex replace.
import re
text = re.sub(
    r'(\s*)Text\(\s*"المركز: \",\s*style: AppTextStyles\.labelMd\.copyWith\(fontWeight: FontWeight\.bold\),\s*\),',
    r'\1Text(\n\1  "المركز: ",\n\1  style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),\n\1  maxLines: 1,\n\1  overflow: TextOverflow.ellipsis,\n\1),',
    text
)

# And check empty state again. I noticed "Expanded child text in text: True" but did it actually wrap the text?
text = re.sub(
    r'(\s*)Text\(\s*"لا توجد زيارات مخالفة تحتاج مراجعتك",\s*style: AppTextStyles\.bodyMedium\.copyWith\(color: AppColors\.onSurfaceVariant\),\s*\),',
    r'\1Expanded(\n\1  child: Text(\n\1    "لا توجد زيارات مخالفة تحتاج مراجعتك",\n\1    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),\n\1  ),\n\1),',
    text
)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(text)

