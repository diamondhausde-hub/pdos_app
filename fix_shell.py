import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

import re

old_actions_match = re.search(r'actions: \[\s*if \(user\?\.fullProfileImageUrl \!= null\).*?const NotificationActionIcon\(\),\s*const SizedBox\(width: 8\),\s*\],', text, re.DOTALL)
if old_actions_match:
    old_actions = old_actions_match.group(0)
    new_actions = '''actions: [
          const NotificationActionIcon(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            color: AppColors.onSurface,
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: 8),
        ],'''
    text = text.replace(old_actions, new_actions)
    
    with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
        f.write(text)
    print("Replaced actions")
else:
    print("Match not found")
