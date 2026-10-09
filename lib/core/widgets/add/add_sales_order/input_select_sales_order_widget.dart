import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/models/product.dart';


class InputSelectSalesOrderWidget extends StatefulWidget {
  final dynamic head, placeholder, necessary, formKey;
  final List<Product?> products;
  final Product? value;
  final Function(Product?) onChanged;

  const InputSelectSalesOrderWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.formKey,
    required this.products,
    required this.value,
    required this.onChanged,
  });

  @override
  State<InputSelectSalesOrderWidget> createState() =>
      _InputSelectSalesOrderWidgetState();
}

class _InputSelectSalesOrderWidgetState
    extends State<InputSelectSalesOrderWidget> {
  bool hasError = false;
  String dataError = "";
  bool isFocus = false;

  @override
  Widget build(BuildContext context) {
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
                          color: AppColors.blueLineShadow, spreadRadius: 4),
                      BoxShadow(
                        color: AppColors.shadowBox,
                        spreadRadius: 0.w,
                        blurRadius: 9.w,
                      )
                    ]
                  : [
                      BoxShadow(color: Colors.white, spreadRadius: 2),
                      BoxShadow(
                        color: AppColors.shadowBox,
                        spreadRadius: 0.w,
                        blurRadius: 9.w,
                      )
                    ],
            ),
            child: Focus(
              onFocusChange: (value) {
                setState(() {
                  isFocus = value;
                });
              },
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Product>(
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(6.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  hint: Container(
                    width: 320.w,
                    child: Text(
                      "-- Select --",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: AppFontWeight.regular,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  value: widget.value,
                  onChanged: widget.onChanged,
                  items: widget.products
                      .map<DropdownMenuItem<Product>>((Product? value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(
                        value!.productName,
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
