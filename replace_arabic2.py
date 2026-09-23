import re

replacements = {
    # Rep Shell
    "lbl_41": "My Day",
    "lbl_42": "Schedule",
    "lbl_43": "Directory",
    "lbl_24": "More",
    
    # Supervisor Shell
    "lbl_25": "Map",
    "lbl_26": "Team",
    "lbl_27": "Visits",
    "lbl_28": "Review",
    "lbl_29": "Review Reports & Tasks",
    "lbl_30": "Performance",
    "lbl_31": "Sales Statistics",
    "lbl_32": "Inventory",
    "lbl_33": "Product Inventory",
    "lbl_34": "Centers",
    "lbl_35": "Manage Centers",
    
    # Other fixes
    "lbl_71": "Schedule Appointment",
    "lbl_40": "Details",
    "lbl_38": "Not found",
}

with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

for lbl_key, eng_val in replacements.items():
    content = re.sub(rf"static const String {lbl_key} = '[^']+';", f"static const String {lbl_key} = '{eng_val}';", content)

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
