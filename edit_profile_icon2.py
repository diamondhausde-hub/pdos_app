import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

# Add import
if "import '../../../core/providers/auth_provider.dart';" not in text:
    text = text.replace("import 'package:go_router/go_router.dart';", "import 'package:go_router/go_router.dart';\nimport '../../../core/providers/auth_provider.dart';")

# Fix the duplicate user variables
text = text.replace('''  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);''', '  Widget build(BuildContext context) {')

# Add only to the main shell
old_shell_build = '''  @override
  Widget build(BuildContext context) {
    return Scaffold('''
new_shell_build = '''  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold('''
if 'final user = ref.watch(currentUserProvider);' not in text:
    text = text.replace(old_shell_build, new_shell_build)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
