import re

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''      if (mounted) {
        showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id);
      }''', '''      if (mounted) {
        showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id, initialClientObj: _selectedClient);
      }''')

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
