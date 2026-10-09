import os

date_picker = """import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/custom_mingda_date_picker.dart';

class DatePickerWidget extends StatefulWidget {
  final dynamic head, controller, placeholder, necessary, formKey, isShort, feature;
  final double? width;

  const DatePickerWidget({
    super.key,
    required this.head,
    required this.controller,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
    this.isShort = false,
    required this.feature,
    this.width,
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  bool hasError = false;
  String dataError = "";
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? (widget.isShort ? 145.w : 335.w),
      height: !hasError ? 75.w : 90.w,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            height: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(
                color: Colors.transparent,
                width: 1.5.w,
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              readOnly: true,
              focusNode: focusNode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  setState(() {
                    hasError = true;
                    dataError = "Wajib diisi";
                  });
                  return null;
                }
                setState(() {
                  hasError = false;
                });
                return null;
              },
              onTap: () async {
                DateTime? pickedDate = await showDialog<DateTime>(
                  context: context,
                  builder: (context) => CustomMingdaDatePicker(
                    initialDate: DateTime.now(),
                  ),
                );
                if (pickedDate != null) {
                  final dateFormated =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                  widget.controller.text = dateFormated;
                }
              },
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: AppFontWeight.regular,
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
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: SvgPicture.asset(
                          "assets/icons/price_tag.svg",
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
                      hintText: "${widget.head}",
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
                          "assets/icons/calendar_month.svg",
                          width: 20.w,
                          height: 20.w,
                        ),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        maxWidth: 50.w,
                        maxHeight: 50.w,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.w),
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
"""

input_short = """import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class InputShortWidget extends StatefulWidget {
  final dynamic head, controller, placeholder, necessary, iconAsset, formKey;
  final double? width;

  const InputShortWidget({
    super.key,
    required this.head,
    required this.controller,
    required this.placeholder,
    required this.necessary,
    this.iconAsset = '',
    required this.formKey,
    this.width,
  });

  @override
  State<InputShortWidget> createState() => _InputShortWidgetState();
}

class _InputShortWidgetState extends State<InputShortWidget> {
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
    return Container(
      width: widget.width ?? 146.w,
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
            height: 45.w,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10.w),
              border: Border.all(
                color: isFocus ? const Color(0xFF0F172A) : Colors.transparent,
                width: 1.5.w,
              ),
            ),
            child: Focus(
              onFocusChange: (value) {
                setState(() {
                  isFocus = value;
                });
              },
              child: TextFormField(
                maxLength: 30,
                buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        required maxLength}) =>
                    null,
                controller: widget.controller,
                focusNode: focusNode,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      hasError = true;
                      dataError = "${widget.head} wajib diisi";
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
                        suffixIcon: widget.iconAsset.toString().isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: SvgPicture.asset(
                                  "assets/icons/${widget.iconAsset}",
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
                        hintText: "${widget.head}",
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.greyPlacholder,
                          fontSize: 13.sp,
                          fontWeight: AppFontWeight.regular,
                        ),
                        suffixIcon: widget.iconAsset.toString().isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(right: 10.w),
                                child: SvgPicture.asset(
                                  "assets/icons/${widget.iconAsset}",
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
                              color: Colors.red),
                        ),
                      ],
                    ),
                    SizedBox(),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
"""

with open(r'D:\Project\Flutter\mierp\lib\core\widgets\date_picker_widget.dart', 'w', encoding='utf-8') as f:
    f.write(date_picker)

with open(r'D:\Project\Flutter\mierp\lib\core\widgets\input_short_widget.dart', 'w', encoding='utf-8') as f:
    f.write(input_short)
