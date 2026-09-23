import codecs
import re

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    content = f.read()

# Remove the widget call
content = re.sub(r'\s*const _BrandSwitcherSection\(\),\s*const SizedBox\(height: 16\),', '', content)

# Remove the class definition
# Search for class _BrandSwitcherSection extends ConsumerWidget ... up to the end of the class
# It ends right before `class _QuickActionsSection extends StatelessWidget {`
class_pattern = r'class _BrandSwitcherSection extends ConsumerWidget \{.*?(?=class _QuickActionsSection extends StatelessWidget)'
content = re.sub(class_pattern, '', content, flags=re.DOTALL)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(content)
