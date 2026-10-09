import 'package:flutter/material.dart';
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
    this.feature = '',
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
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
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
                    title: "PILIH ${widget.head.toString().toUpperCase()}",
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
