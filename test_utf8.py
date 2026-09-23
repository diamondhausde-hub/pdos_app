
import codecs
import re
import sys

# Windows console may not print utf-8 easily, so we just check if it contains the corrupted sequence
with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    text = f.read()

if "نظرة عامة على الفريق" in text:
    print("MATCHES REAL ARABIC")
else:
    print("CORRUPTED")

