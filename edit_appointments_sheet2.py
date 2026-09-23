import re

def fix_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    
    text = re.sub(r'Navigator\.pop\(ctx\);\s*if \(appt\.centerId != null\) \{\s*context\.push\(\'/rep/center/\$\{appt\.centerId\}\'\);\s*\}', '''Navigator.pop(ctx);
                  if (appt.clientId != null) {
                    context.push('/clients/\');
                  } else if (appt.centerId != null) {
                    context.push('/center/\');
                  }''', text)

    text = text.replace('Text(AppStrings.viewCenterProfile, style: TextStyle(fontWeight: FontWeight.bold))', 'Text(appt.clientId != null ? AppStrings.viewProfile : AppStrings.viewCenterProfile, style: TextStyle(fontWeight: FontWeight.bold))')
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)

fix_file('lib/features/rep/screens/appointments_tab.dart')
fix_file('lib/features/supervisor/screens/rep_appointments_screen.dart')

print("Done")
