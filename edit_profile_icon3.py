import codecs

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'r', 'utf-8') as f:
    text = f.read()

# Normalize line endings to LF for easier replacing
text = text.replace('\r\n', '\n')

old_shell_build = '''  @override
  Widget build(BuildContext context) {
    return Scaffold('''
new_shell_build = '''  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    return Scaffold('''

text = text.replace(old_shell_build, new_shell_build)

with codecs.open('lib/features/supervisor/screens/supervisor_shell.dart', 'w', 'utf-8') as f:
    f.write(text)
