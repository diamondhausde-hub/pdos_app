import os

search_str = "المواعيد"

for root, dirs, files in os.walk("lib"):
    for f in files:
        if f.endswith(".dart"):
            filepath = os.path.join(root, f)
            with open(filepath, "r", encoding="utf-8") as file:
                content = file.read()
                if search_str in content:
                    print(f"Found in {filepath}")
