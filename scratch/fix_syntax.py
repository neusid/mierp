import re

def fix_date_picker():
    path = r'D:\Project\Flutter\mierp\lib\core\widgets\date_picker_widget.dart'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    dec_regex = r'decoration: hasError\s*\?\s*InputDecoration\([\s\S]*?\)\s*:\s*InputDecoration\([\s\S]*?\),'
    new_dec = """decoration: hasError
                  ? InputDecoration(
                      errorMaxLines: 1,
                      errorText: '',
                      errorStyle: TextStyle(
                        color: Colors.transparent,
                        fontSize: 0,
                      ),
                      hintText: \"${widget.head}\",
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.greyPlacholder,
                        fontSize: 13.sp,
                        fontWeight: AppFontWeight.regular,
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(
                          \"assets/icons/price_tag.svg\",
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        maxWidth: 50.w,
                        maxHeight: 50.w,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.w),
                    )
                  : InputDecoration(
                      hintText: \"${widget.head}\",
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.greyPlacholder,
                        fontSize: 13.sp,
                        fontWeight: AppFontWeight.regular,
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(
                          \"assets/icons/calendar_month.svg\",
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        maxWidth: 50.w,
                        maxHeight: 50.w,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.w),
                    ),"""

    content = re.sub(dec_regex, new_dec, content)
    
    if "final double? width;" not in content:
        content = content.replace('final dynamic head, controller, placeholder, necessary, formKey, isShort, feature;', 'final dynamic head, controller, placeholder, necessary, formKey, isShort, feature;\n  final double? width;')
        content = content.replace('required this.feature,\n  });', 'required this.feature,\n    this.width,\n  });')
        content = content.replace('width: widget.isShort ? 145.w : 335.w,', 'width: widget.width ?? (widget.isShort ? 145.w : 335.w),')

    old_dec = '''decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.w),
              boxShadow: [
                BoxShadow(color: Colors.white, spreadRadius: 2),
                BoxShadow(
                  color: AppColors.shadowBox,
                  spreadRadius: 0.w,
                  blurRadius: 9.w,
                )
              ],
            ),'''
    new_dec = '''decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(
                color: Colors.transparent,
                width: 1.5.w,
              ),
            ),'''
    content = content.replace(old_dec, new_dec)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

def fix_input_short():
    path = r'D:\Project\Flutter\mierp\lib\core\widgets\input_short_widget.dart'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    dec_regex = r'decoration: hasError\s*\?\s*InputDecoration\([\s\S]*?\)\s*:\s*InputDecoration\([\s\S]*?\),'
    new_dec = """decoration: hasError
                    ? InputDecoration(
                        errorMaxLines: 1,
                        errorText: '',
                        errorStyle: TextStyle(
                          color: Colors.transparent,
                          fontSize: 0,
                        ),
                        hintText: \"${widget.head}\",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.greyPlacholder,
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                        ),
                        suffixIcon: widget.iconAsset.toString().isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: SvgPicture.asset(
                                  \"assets/icons/${widget.iconAsset}\",
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              )
                            : null,
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 50.w,
                          maxHeight: 50.w,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.w),
                      )
                    : InputDecoration(
                        hintText: \"${widget.head}\",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.greyPlacholder,
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                        ),
                        suffixIcon: widget.iconAsset.toString().isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: SvgPicture.asset(
                                  \"assets/icons/${widget.iconAsset}\",
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              )
                            : null,
                        suffixIconConstraints: BoxConstraints(
                          maxWidth: 50.w,
                          maxHeight: 50.w,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.w),
                      ),"""
    content = re.sub(dec_regex, new_dec, content)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

def fix_add_product_order():
    path = r'D:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart'
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = content.replace('AddProductOrderStatus.error', 'AddProductOrderStatus.failure')
    content = content.replace('AppColors.premiumDark.withOpacity(0.2)', 'const Color(0xFF0F172A).withOpacity(0.2)')
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

fix_date_picker()
fix_input_short()
fix_add_product_order()
print("Fixed syntax errors!")
