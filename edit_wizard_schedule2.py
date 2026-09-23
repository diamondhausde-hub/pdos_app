import re

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''              FilledButton.tonalIcon(
                onPressed: _saving ? null : () => showScheduleAppointmentSheet(context, ref),
                icon: const Icon(Icons.event_available_rounded),''', '''              FilledButton.tonalIcon(
                onPressed: _saving ? null : () => showScheduleAppointmentSheet(context, ref, initialClientId: _selectedClient?.id, initialClientObj: _selectedClient),
                icon: const Icon(Icons.event_available_rounded),''')

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
