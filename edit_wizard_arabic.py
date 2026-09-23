import re

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("'Quick Add: Only basic information is collected here. Remember to complete the full profile (location, contacts, etc.) from the Clients section later.'", "'إضافة سريعة: سيتم حفظ المعلومات الأساسية فقط. يرجى إكمال باقي الملف (الموقع، التواصل، الخ) لاحقاً.'")

with open('lib/features/rep/screens/doctor_visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
