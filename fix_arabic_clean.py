import codecs
import re
import base64

def b64(s):
    return base64.b64decode(s).decode('utf-8')

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'r', 'utf-8') as f:
    content = f.read()

# Replace corrupted Arabic strings with correct base64-decoded ones
# "جميع البراندات" -> VGV4dCgn2KzZhduM2Lkg2KfZhNio2LHYp9mG2K/Yp9iqJyk=
content = re.sub(r"Text\('[^']*OU.USO1[^']*'\)", b64('VGV4dCgn2KzZhduM2Lkg2KfZhNio2LHYp9mG2K/Yp9iqJyk='), content)

# "براند" -> VGV4dChiLm5hbWUgPz8gJ9io2LHYp9mG2K8nKQ==
content = re.sub(r"Text\(b\.name \?\? '[^']*'\)", b64('VGV4dChiLm5hbWUgPz8gJ9io2LHYp9mG2K8nKQ=='), content)

# "خطأ في التحميل" -> VGV4dCgn2K7YtNijINmB24wg2KfZhNiq2K3ZhduM2LInKQ==
content = re.sub(r"Text\('[^']*OrOO U\?US[^']*'\)", b64('VGV4dCgn2K7YtNijINmB24wg2KfZhNiq2K3ZhduM2LInKQ=='), content)

# "لا توجد أهداف حالياً" -> VGV4dCgi2YTYpyDYqtmI2KzYryDYo9mH2K/Yp9mBINit2KfZhNuM2KciKQ==
content = re.sub(r"Text\(\"[^\"]*U,O  OU\^OO_[^\"]*\"\)", b64('VGV4dCgi2YTYpyDYqtmI2KzYryDYo9mH2K/Yp9mBINit2KfZhNuM2KciKQ=='), content)

# "أخرى" -> J9ij2K7YsdmKJykubmFtZQ==
content = re.sub(r"'[^']*OOrOU%[^']*'\)\.name", b64('J9ij2K7YsdmKJykubmFtZQ=='), content)
content = re.sub(r"'[^']*OOrOU%[^']*'\)\.name", b64('J9ij2K7YsdmKJykubmFtZQ=='), content)

# "هدف عام" -> dGFyZ2V0LnByb2R1Y3ROYW1lID8/ICfZh9iv2YEg2LnYp9mFJw==
content = re.sub(r"target\.productName \?\? '[^']*O1O U\.'", b64('dGFyZ2V0LnByb2R1Y3ROYW1lID8/ICfZh9iv2YEg2LnYp9mFJw=='), content)

with codecs.open('lib/features/supervisor/screens/supervisor_home_tab.dart', 'w', 'utf-8') as f:
    f.write(content)
