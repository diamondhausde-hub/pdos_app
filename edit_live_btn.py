with open('lib/shared/widgets/live_tracking_button.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('Tween(begin: 34.0, end: 90.0)', 'Tween(begin: 34.0, end: 104.0)')

row_replacement = '''                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.success,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Live ON',
                                style: AppTextStyles.labelSm.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),'''

import re
text = re.sub(r'                        child: Row\(\s*mainAxisSize: MainAxisSize\.min,\s*children: \[\s*Container\(\s*width: 6,\s*height: 6,\s*decoration: const BoxDecoration\(\s*shape: BoxShape\.circle,\s*color: AppColors\.success,\s*\),\s*\),\s*const SizedBox\(width: 4\),\s*Text\(\s*\'Live ON\',\s*style: AppTextStyles\.labelSm\.copyWith\(\s*color: AppColors\.success,\s*fontWeight: FontWeight\.bold,\s*\),\s*\),\s*\],\s*\),', row_replacement, text)

with open('lib/shared/widgets/live_tracking_button.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
