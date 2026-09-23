
import codecs
with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

content = content.replace(
    "onTap: () => context.push('/supervisor/schedule-visit'),",
    "onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء اختيار المندوب من قائمة الفريق أولاً لجدولة زيارة'))),"
)

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

