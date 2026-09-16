import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';

class InputAuthWidget extends StatelessWidget {
  final TextEditingController controller;
  InputAuthWidget({super.key, required this.head, required this.controller, required this.placeholder, required this.necessary, required this.isPassword, required this.formKey});

  final head, placeholder, necessary, isPassword, formKey;
  final inputWidgetC = Get.put(InputWidgetController(), tag: UniqueKey().toString());
  RxBool hasError = false.obs;
  RxString dataError = "".obs;
  final loginVieModel = Get.find<LoginViewModel>();

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
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: inputWidgetC.isFocus.value ?
                [BoxShadow(
                    color: hasError.value?Colors.red.shade50:AppColors.blueLineShadow,
                    spreadRadius: 4
                )
                ] : [BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2
                )
                ],
              ),
              child: isPassword ?
              TextFormField(
                maxLength: 30,
                buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
                controller: controller,
                obscureText: inputWidgetC.isNotVisible.value,
                focusNode: inputWidgetC.focusAuthNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    hasError.value = true;
                    dataError.value = "Password wajib diisi";
                    loginVieModel.isValid.value = false;
                    return "";
                  } else {
                    hasError.value = false;
                    loginVieModel.isValid.value = true;
                  }

                  if (value.length <= 8) {
                    hasError.value = true;
                    dataError.value = "Password harus lebih dari 8";
                    loginVieModel.isValid.value = false;
                    return "";
                  } else {
                    hasError.value = false;
                    loginVieModel.isValid.value = true;
                  }
                },
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.regular,
                ),
                decoration: !hasError.value?InputDecoration(
                  hintText: "Enter your password",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.regular,
                    height: 1.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.w),
                      borderSide: BorderSide(color: AppColors.blueLine,
                          width: 1.w)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.w),
                      borderSide: BorderSide(color: AppColors.coolGray,
                          width: 1.w)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 12.5.w),
                  suffixIcon: IconButton(
                    icon: inputWidgetC.isNotVisible.value ? Icon(
                        Icons.visibility_off) : Icon(Icons.visibility),
                    onPressed: () => inputWidgetC.changeIsNotVisible(),
                  ),
                ):InputDecoration(
                  errorMaxLines: 1,
                  errorText: '',
                  errorStyle: TextStyle(
                    color: Colors.transparent,
                    fontSize: 0,
                  ),
                  hintText: "Enter your password",
                  hintStyle: GoogleFonts.inter(
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
                      borderSide: BorderSide(color: AppColors.coolGray,
                          width: 1.w)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 12.5.w),
                  suffixIcon: IconButton(
                    icon: inputWidgetC.isNotVisible.value ? Icon(
                        Icons.visibility_off) : Icon(Icons.visibility),
                    onPressed: () => inputWidgetC.changeIsNotVisible(),
                  ),
                ),
              ) :
              TextFormField(
                maxLength: 30,
                keyboardType: TextInputType.emailAddress,
                buildCounter: (context, {required currentLength, required isFocused, required maxLength}) => null,
                controller: controller,
                focusNode: inputWidgetC.focusAuthNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    hasError.value = true;
                    dataError.value = "Email wajib diisi";
                    loginVieModel.isValid.value = false;
                    return null;
                  } else {
                    hasError.value = false;
                    dataError.value = "";
                    loginVieModel.isValid.value = true;
                  }

                  if (!value.contains('@') || !value.contains('.')) {
                    hasError.value = true;
                    dataError.value = "Format email salah";
                    loginVieModel.isValid.value = false;
                    return null;
                  } else {
                    hasError.value = false;
                    dataError.value = "";
                    loginVieModel.isValid.value = true;
                  }
                },
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: AppFontWeight.regular,
                ),
                decoration: hasError.value?InputDecoration(
                  errorMaxLines: 1,
                  errorText: '',
                  errorStyle: TextStyle(
                    color: Colors.transparent,
                    fontSize: 0,
                  ),
                  hintText: "Enter your email",
                  hintStyle: GoogleFonts.inter(
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
                      borderSide: BorderSide(color: AppColors.coolGray,
                          width: 1.w)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 12.5.w),
                ):InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.regular,
                    height: 1.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.w),
                      borderSide: BorderSide(color: AppColors.blueLine,
                          width: 1.w)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6.w),
                      borderSide: BorderSide(color: AppColors.coolGray,
                          width: 1.w)
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 8.w, vertical: 12.5.w),
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
    });
  }
}

