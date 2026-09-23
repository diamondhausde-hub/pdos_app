import re

with open('lib/features/shared/screens/clients_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

replacement_list = '''                    Row(
                      children: [
                        Expanded(
                          child: Text(name, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),
                        ),
                        if (client.status == 'incomplete')
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Incomplete', style: AppTextStyles.labelSm.copyWith(color: AppColors.warning)),
                          ),
                      ],
                    ),'''

text = text.replace("Text(name, style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface)),", replacement_list, 1)

replacement_grid = '''              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (client.status == 'incomplete')
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text('!', style: AppTextStyles.labelSm.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                    ),
                ],
              ),'''

text = text.replace('''              Text(
                name,
                style: AppTextStyles.bodyMd.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),''', replacement_grid, 1)

with open('lib/features/shared/screens/clients_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
