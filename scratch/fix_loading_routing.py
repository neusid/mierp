import re

file_path = r"d:\Project\Flutter\mierp\lib\core\routing\app_routes.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace("import 'package:mierp_apps/features/loading/loading_binding.dart';", "")
code = code.replace("      binding: LoadingBinding(),\n", "")

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Loading routing fixed")
