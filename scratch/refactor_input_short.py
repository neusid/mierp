import re

file_path = r"d:\Project\Flutter\mierp\lib\core\widgets\input_short_widget.dart"
with open(file_path, 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace(
    "InputShortWidget({super.key, required this.head, required this.controller, required this.placeholder, required this.necessary, required this.iconAsset, required this.formKey});",
    "InputShortWidget({super.key, required this.head, required this.controller, required this.placeholder, required this.necessary, this.iconAsset = '', required this.formKey});"
)

# Conditionally show suffixIcon
old_suffix = """suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: SvgPicture.asset(
                        "assets/icons/$iconAsset",
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),"""
new_suffix = """suffixIcon: iconAsset.toString().isNotEmpty ? Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: SvgPicture.asset(
                        "assets/icons/$iconAsset",
                        width: 20.w,
                        height: 20.w,
                      ),
                    ) : null,"""
code = code.replace(old_suffix, new_suffix)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(code)

print("Refactored InputShortWidget")
