
import codecs
import re
with codecs.open("lib/core/router/app_router.dart", "r", "utf-8") as f:
    content = f.read()

content = re.sub(
    r"case UserRole\.generalManager:\s*return[^;]+;\s*case UserRole\.supervisor:",
    "case UserRole.generalManager:\n              return '/general-manager/overview';\n            case UserRole.overseer:\n              return '/overseer/overview';\n            case UserRole.supervisor:",
    content
)
# Wait I wrote ' inside Python which will be ' in Dart if it wasn't replaced by PowerShell?
# Actually inside PowerShell single quotes, ' becomes ' (literal two quotes? No, it escapes to a single quote!). 

