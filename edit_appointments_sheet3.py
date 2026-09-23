import re

def fix_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        text = f.read()
    
    text = text.replace('''Navigator.pop(ctx);
                  if (appt.clientId != null) {
                    context.push('/clients/');
                  } else if (appt.centerId != null) {
                    context.push('/center/');
                  }''', '''Navigator.pop(ctx);
                  if (appt.clientId != null) {
                    context.push(f"/clients/{appt.clientId}");
                  } else if (appt.centerId != null) {
                    context.push(f"/center/{appt.centerId}");
                  }''')
                  
    text = text.replace('''context.push(f"/clients/{appt.clientId}");''', '''context.push('/clients/${appt.clientId}');''')
    text = text.replace('''context.push(f"/center/{appt.centerId}");''', '''context.push('/center/${appt.centerId}');''')

    with open(path, 'w', encoding='utf-8') as f:
        f.write(text)

fix_file('lib/features/rep/screens/appointments_tab.dart')
fix_file('lib/features/supervisor/screens/rep_appointments_screen.dart')

print("Done")
