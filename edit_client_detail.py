import re

with open('lib/features/shared/screens/client_detail_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

replacement = '''
          data: (clients) {
            final client = clients.where((c) => c.id == widget.clientId).firstOrNull;
            if (client == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_off_rounded, size: 64, color: AppColors.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(AppStrings.clientNotFound, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (client.status == 'incomplete')
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    color: AppColors.warning.withValues(alpha: 0.1),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'This profile is incomplete. Please edit to add full details.',
                            style: AppTextStyles.bodySm.copyWith(color: AppColors.warning, fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/clients/edit/\'),
                          child: const Text('Edit'),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
'''

original_search = '''          data: (clients) {
            final client = clients.where((c) => c.id == widget.clientId).firstOrNull;
            if (client == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_off_rounded, size: 64, color: AppColors.onSurfaceVariant),
                    const SizedBox(height: 12),
                    Text(AppStrings.clientNotFound, style: AppTextStyles.bodyLg.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: ['''

if original_search in text:
    text = text.replace(original_search, replacement)
    
    # Now replace the bottom
    # We look for the end of the SingleChildScrollView which is:
    #                 const SizedBox(height: 100),
    #               ],
    #             ),
    #           );
    #         },
    
    bottom_search = '''                const SizedBox(height: 100),
              ],
            ),
          );
        },'''
        
    bottom_replace = '''                const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
        },'''
        
    text = text.replace(bottom_search, bottom_replace)
    
    with open('lib/features/shared/screens/client_detail_screen.dart', 'w', encoding='utf-8') as f:
        f.write(text)
    print("Done")
else:
    print("Search string not found")

