import re

def fix_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    
    original = '''              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (appt.centerId != null) {
                    context.push('/rep/center/');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(AppStrings.viewCenterProfile, style: TextStyle(fontWeight: FontWeight.bold)),
              ),'''

    replacement = '''              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (appt.clientId != null) {
                    context.push('/clients/\');
                  } else if (appt.centerId != null) {
                    context.push('/center/\');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  appt.clientId != null ? AppStrings.viewProfile : AppStrings.viewCenterProfile, 
                  style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ),'''
    
    text = text.replace(original, replacement)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)

fix_file('lib/features/rep/screens/appointments_tab.dart')
fix_file('lib/features/supervisor/screens/rep_appointments_screen.dart')

print("Done")
