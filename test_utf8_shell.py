
import codecs
with codecs.open("lib/features/supervisor/screens/supervisor_shell.dart", "r", "utf-8") as f:
    text = f.read()

if "الإعدادات" in text or "عن التطبيق" in text:
    print("MATCHES REAL ARABIC")
else:
    print("CORRUPTED")

