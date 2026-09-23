
import codecs

with codecs.open("lib/features/supervisor/screens/target_list_screen.dart", "r", "utf-8") as f:
    content = f.read()

old_init = """  @override
  void initState() {
    super.initState();
    ref.invalidate(targetsProvider);
  }"""

new_init = """  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(targetsProvider);
    });
  }"""

content = content.replace(old_init, new_init)

with codecs.open("lib/features/supervisor/screens/target_list_screen.dart", "w", "utf-8") as f:
    f.write(content)

