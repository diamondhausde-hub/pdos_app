import base64
import codecs
import re

with codecs.open('make_home2.py', 'r', 'utf-8') as f:
    text = f.read()

# Just extract anything between quotes if it's the large base64 block
b64_str = ''
for line in text.split('\n'):
    if line.startswith('b64 = "') or line.startswith("b64 = '"):
        b64_str = line[7:-1]
        break
    elif line.startswith('b64 = b"'):
        b64_str = line[8:-1]
        break

if not b64_str:
    b64_match = re.search(r'b64\s*=\s*[\'"]([A-Za-z0-9+/=]+)[\'"]', text)
    if b64_match:
        b64_str = b64_match.group(1)

content = base64.b64decode(b64_str).decode('utf-8')

# Fix the syntax error (, -> ),
content = content.replace('                (,\n                SliverFillRemaining(', '                ),\n                SliverFillRemaining(')

# Fix HeaderSection name handling
old_header = "final name = user?.fullName.split(' ').first ?? 'Supervisor';"
new_header = '''final rawName = user?.fullName.split(' ').first ?? '';
    final name = rawName.isEmpty ? 'Supervisor' : rawName;'''
content = content.replace(old_header, new_header)

# Fix empty state Expanded
old_empty = '''                    Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    Text(
                      "لا توجد زيارات مخالفة تحتاج مراجعتك",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                    ),'''
new_empty = '''                    Icon(Icons.check_circle_outline_rounded, color: AppColors.success),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "لا توجد زيارات مخالفة تحتاج مراجعتك",
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                    ),'''
content = content.replace(old_empty, new_empty)

# Fix center name text overflow
old_center = '''                  Text(
                    "المركز: \",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                  ),'''
new_center = '''                  Text(
                    "المركز: \",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),'''
content = content.replace(old_center, new_center)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(content)
