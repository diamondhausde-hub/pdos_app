import re

with open('lib/features/shared/widgets/schedule_appointment_sheet.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace('''Future<void> showScheduleAppointmentSheet(''', '''Future<bool?> showScheduleAppointmentSheet(''')
text = text.replace('''await showModalBottomSheet(''', '''return await showModalBottomSheet<bool>(''')
text = text.replace('''if (mounted) {
        Navigator.pop(context);''', '''if (mounted) {
        Navigator.pop(context, true);''')

with open('lib/features/shared/widgets/schedule_appointment_sheet.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
