import re
with open('lib/features/rep/screens/visit_wizard_screen.dart', 'r', encoding='utf-8') as f:
    text = f.read()

original = '''    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _showPermissionDeniedDialog(context);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) _showPermissionDeniedDialog(context);
      return;
    }'''

replacement = '''    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          _showPermissionDeniedDialog(context);
          setState(() => _isLoading = false);
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        _showPermissionDeniedDialog(context);
        setState(() => _isLoading = false);
      }
      return;
    }'''

text = text.replace(original, replacement)

text = text.replace('''    final user = ref.read(currentUserProvider);
    if (user == null) return;''', '''    final user = ref.read(currentUserProvider);
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }''')

with open('lib/features/rep/screens/visit_wizard_screen.dart', 'w', encoding='utf-8') as f:
    f.write(text)

print("Done")
