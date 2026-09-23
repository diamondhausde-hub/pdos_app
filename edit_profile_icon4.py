import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

# Normalize line endings
text = text.replace('\r\n', '\n')

old_actions = '''        actions: [
          const NotificationActionIcon(),
          const SizedBox(width: 8),
        ],'''

new_actions = '''        actions: [
          if (user?.fullProfileImageUrl != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () => context.push('/shared/settings'),
                borderRadius: BorderRadius.circular(14),
                child: CircleAvatar(
                  radius: 14,
                  backgroundImage: NetworkImage(user!.fullProfileImageUrl!),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: InkWell(
                onTap: () => context.push('/shared/settings'),
                borderRadius: BorderRadius.circular(14),
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
            ),
          const SizedBox(width: 4),
          const NotificationActionIcon(),
          const SizedBox(width: 8),
        ],'''

text = text.replace(old_actions, new_actions)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
