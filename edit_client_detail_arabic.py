import re

with open('lib/features/shared/screens/client_detail_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("'This profile is incomplete. Please edit to add full details.'", "'ملف الطبيب غير مكتمل، أكمل ما تبقى من البيانات.'")

with open('lib/features/shared/screens/client_detail_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
