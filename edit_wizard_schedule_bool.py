import re

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

replacement = '''    if (_step == 1 && _action == _Action.schedule) {
      if (_mode == _VisitMode.newDoctor && _selectedClient == null) {
        await _saveDoctorQuickly();
      }
      if (mounted) {
        final result = await showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id, initialClientObj: _selectedClient);
        if (result == true && mounted) {
          context.go('/rep/my-day'); // Navigate away or pop if they scheduled successfully
        }
      }
      return;
    }'''

original_search = '''    if (_step == 1 && _action == _Action.schedule) {
      if (_mode == _VisitMode.newDoctor && _selectedClient == null) {
        await _saveDoctorQuickly();
      }
      if (mounted) {
        showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id, initialClientObj: _selectedClient);
      }
      return;
    }'''

if original_search in text:
    text = text.replace(original_search, replacement)
    with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
        f.write(text)
    print("Done")
else:
    print("Not found")

