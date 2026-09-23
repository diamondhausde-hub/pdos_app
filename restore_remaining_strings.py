with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

new_strings = """
  static const String addClientPharmacy = 'Add Client/Pharmacy';
  static const String name = 'Name';
  static const String u0627U0633U0645U0627 = 'Center/Doctor Name';
  static const String u0645U0643U0627U0646 = 'Location';
  static const String u0645U0644U0627U062d = 'Notes';
  static const String scheduleFollowUp_68 = 'Schedule Follow Up';
  static const String doYouWantTo = 'Do you want to schedule a follow up?';
  static const String noLater = 'No, later';
  static const String yesSchedule = 'Yes, schedule';
  static const String saveClient = 'Save Client';
  static const String selectClient = 'Select Client';
  static const String searchByNameOr = 'Search by name or specialty';
  static const String addNewClient = 'Add New Client';
  static const String stayUpToDate = 'Stay up to date';
  static const String noNotificationsYet = 'No notifications yet';
  static const String deleteNotification = 'Delete Notification';
  static const String areYouSureYou_69 = 'Are you sure you want to delete this notification?';
  static const String deleteAllNotifications = 'Delete All Notifications';
  static const String areYouSureYou_70 = 'Are you sure you want to delete all notifications?';
"""

content = content.replace("}", new_strings + "}")

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Restored remaining missing strings")
