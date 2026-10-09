import re

view_path = r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_unit\add_unit_view.dart"
with open(view_path, 'r', encoding='utf-8') as f:
    view_code = f.read()

# Fix image picking
view_code = view_code.replace("""                                      addUnitVM.imageFile.value = image;

                                      print(image);""", """                                      if (image != null) {
                                        setState(() {
                                          imageFile = image;
                                        });
                                      }""")

# Fix Obx around image
# The Obx starts at line 219: `child: Obx(` and ends at `),` around line 256.
view_code = re.sub(
    r"child:\s*Obx\(\s*\(\)\s*=>\s*DottedBorder\([\s\S]*?child:\s*Center\([\s\S]*?child:\s*addUnitVM\.imageFile\.value\s*!=\s*null[\s\S]*?ClipRRect\([\s\S]*?child:\s*Image\.file\([\s\S]*?File\([\s\S]*?addUnitVM\s*\.imageFile\s*\.value!\s*\.path,[\s\S]*?\),[\s\S]*?fit:\s*BoxFit\.contain,[\s\S]*?\),[\s\S]*?\)[\s\S]*?:\s*Image\.asset\([\s\S]*?\"assets/images/galery_add\.png\",[\s\S]*?height:\s*48\.h,[\s\S]*?\),[\s\S]*?\),[\s\S]*?\),[\s\S]*?\),",
    """child: Builder(builder: (context) => DottedBorder(
                                          options:
                                              RoundedRectDottedBorderOptions(
                                                radius: Radius.circular(10.w),
                                                color: AppColors.coolGray,
                                                dashPattern: [10, 10],
                                                strokeWidth: 2.w,
                                              ),
                                          child: Center(
                                            child:
                                                imageFile != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.w,
                                                        ),
                                                    child: Image.file(
                                                      File(imageFile!.path),
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    "assets/images/galery_add.png",
                                                    width: 48.w,
                                                    height: 48.h,
                                                  ),
                                          ),
                                        ),
                                      ),""",
    view_code
)


# Fix the Obx loading block at the bottom
# It starts at:
#             Obx(
#               () => addUnitVM.isLoading.value == true
#                   ? Container(
# ...
#                   : SizedBox(),
#             ),
loading_regex = r"Obx\(\s*\(\)\s*=>\s*addUnitVM\.isLoading\.value\s*==\s*true[\s\S]*?\? Container\([\s\S]*?child:\s*LoadingAnimationWidget\.stretchedDots\([\s\S]*?\)[\s\S]*?\): SizedBox\(\),\s*\),"
new_loading = """state.status == AddUnitStatus.loading
                  ? Container(
                      color: Colors.black26,
                      child: Center(
                        child: LoadingAnimationWidget.stretchedDots(
                          color: AppColors.softWhite,
                          size: 70.w,
                        ),
                      ),
                    )
                  : SizedBox(),"""
view_code = re.sub(loading_regex, new_loading, view_code)

# Ensure proper closing of BlocConsumer and BlocProvider
view_code = re.sub(r"\}\);[\s\n]*\}[\s\n]*\}", 
                   "});\n        },\n      ),\n    );\n  }\n}", view_code)


with open(view_path, 'w', encoding='utf-8') as f:
    f.write(view_code)

print("Fixed add_unit_view part 2")
