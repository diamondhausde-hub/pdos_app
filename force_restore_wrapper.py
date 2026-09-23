with open("lib/features/rep/screens/rep_shell.dart", "a", encoding="utf-8") as f:
    f.write("""
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
""")
