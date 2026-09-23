import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

# Replace build signature to add user
old_build = '  Widget build(BuildContext context) {'
new_build = '''  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);'''
if 'final user = ref.watch(currentUserProvider);' not in text:
    text = text.replace(old_build, new_build)

# Replace actions
old_actions = '''        actions: [
          const NotificationActionIcon(),
          const SizedBox(width: 8),
        ],'''

new_actions = '''        actions: [
          if (user?.fullProfileImageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(user!.fullProfileImageUrl!),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (user?.fullName ?? 'U').isNotEmpty
                        ? (user?.fullName ?? 'U').substring(0, 1).toUpperCase()
                        : 'U',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 4),
          const NotificationActionIcon(),
          const SizedBox(width: 8),
        ],'''

text = text.replace(old_actions, new_actions)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
