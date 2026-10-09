import re

def fix_hint():
    file_path = r'd:\Project\Flutter\mierp\lib\features\summary\presentation\summary_view.dart'
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    target = """                                        hint: Text(
                                          "Search anything...",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.grayThin,
                                          ),
                                        ),"""
                                        
    replacement = """                                        hintText: "Search anything...",
                                        hintStyle: GoogleFonts.inter(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.grayThin,
                                        ),"""

    if target in content:
        content = content.replace(target, replacement)
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print("Fixed hint!")
    else:
        print("hint not found.")

fix_hint()
