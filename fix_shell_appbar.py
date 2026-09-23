import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

import re

# Add auth_provider back if missing
if "import '../../../core/providers/auth_provider.dart';" not in text:
    text = text.replace("import 'package:go_router/go_router.dart';", "import 'package:go_router/go_router.dart';\nimport '../../../core/providers/auth_provider.dart';")

# Re-add user inside build
text = re.sub(
    r'  Widget build\(BuildContext context\) \{\s*return Scaffold\(',
    r'  Widget build(BuildContext context) {\n    final user = ref.watch(currentUserProvider);\n    return Scaffold(',
    text
)

# Replace AppBar title
old_title_match = re.search(r'title: Row\([\s\S]*?Text\(\s*\'لوحة تحكم المشرف\'[\s\S]*?,\s*\),[\s\S]*?\],\s*\),', text)
if old_title_match:
    old_title = old_title_match.group(0)
    new_title = '''title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user?.fullProfileImageUrl != null)
              CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(user!.fullProfileImageUrl!),
              )
            else
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (user?.fullName ?? 'S').isNotEmpty
                        ? (user?.fullName ?? 'S').substring(0, 1).toUpperCase()
                        : 'S',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                user?.fullName.split(' ').first ?? 'Supervisor',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),'''
    text = text.replace(old_title, new_title)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
