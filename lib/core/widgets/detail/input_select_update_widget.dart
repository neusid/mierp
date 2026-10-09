import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';


class InputSelectUpdateWidget extends StatefulWidget {
  final String head, placeholder;
  final bool necessary;
  final GlobalKey<FormState> formKey;
  final String value;
  final ValueChanged<String?> onChanged;

  const InputSelectUpdateWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
    required this.value,
    required this.onChanged,
  });

  @override
  State<InputSelectUpdateWidget> createState() =>
      _InputSelectUpdateWidgetState();
}

class _InputSelectUpdateWidgetState extends State<InputSelectUpdateWidget> {
  bool hasError = false;
  String dataError = "";
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        width: 322.w,
        height: !hasError ? 75.w : 90.w,
        child: Column(
          children: [
            Row(
              children: [
                widget.necessary
                    ? Text(
                        "*",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.medium,
                          color: Colors.red,
                        ),
                      )
                    : SizedBox(),
                Text(
                  widget.head,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.grayTitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.w),
            Container(
              width: 322.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: isFocus
                    ? [
                        BoxShadow(
                          color: AppColors.blueLineShadow,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: AppColors.shadowBox,
                          spreadRadius: 0.w,
                          blurRadius: 9.w,
                        ),
                      ]
                    : [
                        BoxShadow(color: Colors.white, spreadRadius: 2),
                        BoxShadow(
                          color: AppColors.shadowBox,
                          spreadRadius: 0.w,
                          blurRadius: 9.w,
                        ),
                      ],
              ),
              child: Focus(
                onFocusChange: (value) {
                  setState(() {
                    isFocus = value;
                  });
                },
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(6.w),
                    icon: Icon(Icons.arrow_drop_down),
                    value: widget.value,
                    onChanged: (value) {
                      if (value != null) widget.onChanged(value);
                    },
                    items: <String>['electronics', 'automotive']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: AppFontWeight.regular,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            hasError
                ? Column(
                    children: [
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Text(
                            dataError,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: AppFontWeight.regular,
                              height: 1.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : SizedBox(),
          ],
        ),
      );
    });
  }
}
