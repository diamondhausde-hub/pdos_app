with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

new_strings = """
  static const String pharmacyCenterVisit = 'Pharmacy/Center Visit';
  static const String checkInAtA = 'Check in at a center';
  static const String doctorVisit_85 = 'Doctor Visit';
  static const String meetADoctorCapture = 'Meet a doctor';
  static const String visitReport = 'Visit Report';
  static const String salesOrders = 'Sales Orders';
  static const String stockChecks = 'Stock Checks';
  static const String shelfPhotos = 'Shelf Photos';
  static const String signature = 'Signature';
  static const String signatureFileNotFound = 'Signature file not found';
  static const String signatureFileIsEmpty = 'Signature file is empty';
  static const String signatureError = 'Signature error';
"""

content = content.replace("}", new_strings + "}")

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Added missing strings")
