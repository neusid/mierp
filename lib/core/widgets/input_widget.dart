import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';

class InputWidget extends StatelessWidget {
  InputWidget({super.key, required this.head, required this.controller, required this.placeholder, required this.necessary, required this.formKey});

  final head, controller, placeholder, necessary, formKey;
  RxBool hasError = false.obs;
  RxString dataError = "".obs;

  @override
  Widget build(BuildContext context) {

    final inputWidgetC = Get.put(InputWidgetController(), tag: head.toString());

    return Obx(() {
      return Container(
        width: 335.w,
        height: !hasError.value? 75.w:90.w,
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
              width: 335.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: inputWidgetC.isFocus.value ?
                [
                  BoxShadow(color: AppColors.blueLineShadow, spreadRadius: 4),
                  BoxShadow(
                    color: AppColors.shadowBox,
                    spreadRadius: 0.w,
                    blurRadius: 9.w,
                  )
                ] : [
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
                  inputWidgetC.isFocus.value = value;
                },
                child: TextFormField(
                  controller: controller,
                  focusNode: inputWidgetC.focusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      hasError.value = true;
                      dataError.value = "wajib diisi";
                      return null;
                    }
                  },
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.regular,
                    height: 1.0,
                  ),
                  decoration: hasError.value?InputDecoration(
                    errorMaxLines: 1,
                    errorText: '',
                    errorStyle: TextStyle(
                      color: Colors.transparent,
                      fontSize: 0,
                    ),
                    hintText: "$head",
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.greyPlacholder,
                      fontSize: 13.sp,
                      fontWeight: AppFontWeight.regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.w),
                        borderSide: BorderSide(color: AppColors.blueLine,
                            width: 1.w)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.w),
                        borderSide: BorderSide.none
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 12.5.w),
                  ):InputDecoration(
                    hintText: "$head",
                    hintStyle: GoogleFonts.inter(
                      color: AppColors.greyPlacholder,
                      fontSize: 13.sp,
                      fontWeight: AppFontWeight.regular,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.w),
                        borderSide: BorderSide(color: AppColors.blueLine,
                            width: 1.w)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.w),
                        borderSide: BorderSide.none
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.w),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 8.w, vertical: 12.5.w),
                  ),
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
                          color: Colors.red
                      ),
                    ),
                  ],
                ),
              ],
            ) : SizedBox(),
          ],
        ),
      );
    });
  }
}

