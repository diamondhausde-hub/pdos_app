with open("lib/features/rep/screens/rep_shell.dart", "r", encoding="utf-8") as f:
    content = f.read()

screen_wrapper = """

class _ScreenWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  const _ScreenWrapper({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: child,
    );
  }
}
"""

if "_ScreenWrapper" not in content:
    with open("lib/features/rep/screens/rep_shell.dart", "w", encoding="utf-8") as f:
        f.write(content + screen_wrapper)
    print("Restored _ScreenWrapper")
