import re

with open('lib/features/shared/screens/clients_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

text = text.replace("'Incomplete'", "'أكمل ما تبقى'")
text = text.replace("'!'", "'أكمل ما تبقى'")

with open('lib/features/shared/screens/clients_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
