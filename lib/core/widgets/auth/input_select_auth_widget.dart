import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';

class InputSelectAuthWidget extends StatelessWidget {
  final String head, placeholder;
  final bool necessary, isPassword;
  final GlobalKey<FormState> formKey;
  final String value;
  final Function(String?) onChanged;

  InputSelectAuthWidget({
    super.key,
    required this.head,
    required this.placeholder,
    required this.necessary,
    required this.isPassword,
    required this.formKey,
    required this.value,
    required this.onChanged,
  });

  final inputWidgetC = Get.put(InputWidgetController(), tag: UniqueKey().toString());
  RxBool hasError = false.obs;
  RxString dataError = "".obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: 322.w,
        height: 93.w,
        child: Column(
          children: [
            Row(
              children: [
                necessary ?
                Text(
                  "*",
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.medium,
                    color: Colors.red,
                  ),
                ) : SizedBox(),
                Text(
                  head,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.medium,
                    color: AppColors.grayTitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.w,),
            Container(
              width: 322.w,
              // height: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.coolGray,
                    width: 1.w),
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: inputWidgetC.isFocus.value ?
                [BoxShadow(
                    color: AppColors.blueLineShadow,
                    spreadRadius: 4
                )
                ] : [BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2
                )
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  borderRadius: BorderRadius.circular(6.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.5.w),
                  icon: Icon(Icons.arrow_drop_down),
                  value: value,
                  onChanged: onChanged,
                  items: <String>['warehouse','finance'].map<DropdownMenuItem<String>>(
                      (String value) {
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
                      }
                  ).toList(),
                ),
              ),
            ),
            hasError.value ?
            Column(
              children: [
                SizedBox(height: 5.h,),
                Row(
                  children: [
                    Text(
                      dataError.value,
                      style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: AppFontWeight.regular,
                          height: 1.0,
                          color: Colors.red
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h,),
              ],
            ) : SizedBox(height: 20.h,),
          ],
        ),
      );
    },);
  }
}
