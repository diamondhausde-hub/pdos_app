import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    text = f.read()

# 1. Fix HeaderSection
old_header = "final name = user?.fullName.split(' ').first ?? 'Supervisor';"
new_header = '''final rawName = user?.fullName.split(' ').first ?? '';
    final name = rawName.isEmpty ? 'Supervisor' : rawName;'''
text = text.replace(old_header, new_header)

# 2. Fix empty state Expanded
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
text = text.replace(old_empty, new_empty)

# 3. Fix center name text overflow
old_center = '''                  Text(
                    "المركز: ",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                  ),'''
new_center = '''                  Text(
                    "المركز: ",
                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),'''
# Need to use template format due to the dart string interpolation, let's just do a manual string replace
old_center_raw = '                    "المركز: ",\n                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),\n                  ),'
new_center_raw = '                    "المركز: ",\n                    style: AppTextStyles.labelMd.copyWith(fontWeight: FontWeight.bold),\n                    maxLines: 1,\n                    overflow: TextOverflow.ellipsis,\n                  ),'
text = text.replace(old_center_raw, new_center_raw)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(text)
