import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';


class InputWidget extends StatefulWidget {
  final dynamic head, controller, placeholder, necessary, formKey;

  const InputWidget({
    super.key,
    required this.head,
    required this.controller,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
  });

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool hasError = false;
  String dataError = "";
  bool isFocus = false;
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335.w,
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
            width: 335.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(
                color: isFocus ? AppColors.vividPurple : Colors.transparent,
                width: 1.5.w,
              ),
            ),
            child: Focus(
              onFocusChange: (value) {
                if (mounted) {
                  setState(() {
                    isFocus = value;
                  });
                }
              },
              child: TextFormField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: widget.controller,
                focusNode: focusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      hasError = true;
                      dataError = "wajib diisi";
                    });
                    return null;
                  }
                  setState(() {
                    hasError = false;
                  });
                  return null;
                },
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.regular,
                  height: 1.0,
                ),
                decoration: hasError
                    ? InputDecoration(
                        errorMaxLines: 1,
                        errorText: '',
                        errorStyle: TextStyle(
                          color: Colors.transparent,
                          fontSize: 0,
                        ),
                        hintText: "${widget.head}",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.greyPlacholder,
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 12.5.w),
                      )
                    : InputDecoration(
                        hintText: "${widget.head}",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.greyPlacholder,
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                        ),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 12.5.w),
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
                              color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

