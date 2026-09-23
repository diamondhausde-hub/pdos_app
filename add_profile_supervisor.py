with open("lib/features/supervisor/screens/supervisor_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

profile_btn = """
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Icon(Icons.person_outline_rounded, color: AppColors.onSurface, size: 20),
            ),
            onPressed: () => context.push('/profile'),
          ),
          const SizedBox(width: 8),
"""

content = content.replace("const NotificationActionIcon(),\n          const SizedBox(width: 8),", f"const NotificationActionIcon(),\n{profile_btn}")

with open("lib/features/supervisor/screens/supervisor_shell.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Added profile button to supervisor AppBar")
