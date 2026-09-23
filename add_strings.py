with open("lib/core/localization/app_strings.dart", "r", encoding="utf-8") as f:
    content = f.read()

new_strings = """
  static const String trackYourSalesAndGoals = 'Track your sales and goals';
  static const String viewAndSubmitDailyReports = 'View and submit daily reports';
  static const String appVersionAndInfo = 'App version and info';
"""

content = content.replace("}", new_strings + "}")

with open("lib/core/localization/app_strings.dart", "w", encoding="utf-8") as f:
    f.write(content)
print("Added new AppStrings")
