with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

new_strings = """
  static const String specialRequests = 'Special Requests';
  static const String addRequest = 'Add Request';
  static const String noSpecialRequests = 'No special requests';
  static const String invoiceSummary = 'Invoice Summary';
  static const String salesOrder = 'Sales Order';
  static const String noItemsOrdered = 'No items ordered';
  static const String expensesExtras = 'Expenses & Extras';
  static const String downloadSharePdf = 'Download / Share PDF';
  static const String scheduleFollowUp = 'Schedule Follow Up';
  static const String done = 'Done';
  static const String lbl_71 = 'Schedule Appointment';
  static const String lbl_72 = 'Set Date, Time and Target';
  static const String lbl_73 = 'Date';
  static const String lbl_74 = 'Time';
  static const String lbl_75 = 'Center / Client';
  static const String lbl_76 = 'Clear';
  static const String lbl_77 = 'Select Center';
  static const String lbl_78 = 'Select Client';
  static const String lbl_79 = 'Remind me before';
  static const String lbl_80 = 'Choose Center';
  static const String lbl_81 = 'Choose Client';
  static const String lbl_82 = 'Please select a target first';
  static const String lbl_83 = 'Cannot select past dates';
  static const String lbl_84 = 'Scheduled successfully';
  static const String supervisorVisit = 'Supervisor Visit';
  static const String profile = 'Profile';
  static const String achievements = 'Achievements';
  static const String lbl_57 = 'Submit';
  static const String lbl_58 = 'Visit Submitted';
  static const String lbl_59 = 'Submit Visit';
  static const String lbl_60 = 'Write note here...';
"""

content = content.replace("}", new_strings + "}")

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Restored missing strings")
