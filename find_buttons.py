import re, os
for root, _, files in os.walk(r'C:\Users\prot\Documents\PDOS\pdos_app\lib'):
    for file in files:
        if file.endswith('.dart'):
            with open(os.path.join(root, file), 'r', encoding='utf-8') as f:
                content = f.read()
                if "إضافة طبيب" in content or "إضافة صيدلية" in content:
                    print(os.path.join(root, file))
