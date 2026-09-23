
import codecs
import re

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "r", "utf-8") as f:
    content = f.read()

imports = """import 'package:intl/intl.dart';
import 'target_list_screen.dart';
import '../../../core/models/target_model.dart';
"""
content = content.replace("""import 'package:intl/intl.dart';
import '../../../core/models/target_model.dart';
""", imports)

old_btn = """                Center(
                  child: TextButton(
                    onPressed: () {
                      // context.push('/supervisor/targets');
                    },"""

new_btn = """                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const TargetListScreen()));
                    },"""

content = content.replace(old_btn, new_btn)

with codecs.open("lib/features/supervisor/screens/supervisor_home_tab.dart", "w", "utf-8") as f:
    f.write(content)

