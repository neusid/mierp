import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view_model.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';
import 'package:mierp_apps/features/register/presentation/register_view_model.dart';

class InputSelectUpdateWidget extends StatelessWidget {
  InputSelectUpdateWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey});

  final head, placeholder, necessary, formKey;
  final inputWidgetC = Get.put(InputWidgetController(), tag: UniqueKey().toString());
  final detailProductVM = Get.find<DetailProductViewModel>();
  RxBool hasError = false.obs;
  RxString dataError = "".obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: 322.w,
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
              width: 322.w,
              // height: 45.w,
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(6.w),
                  icon: Icon(Icons.arrow_drop_down),
                  value: detailProductVM.categoryProductC.value,
                  onChanged: (value) {
                    detailProductVM.categoryProductC.value = value!;
                  },
                  items: <String>['electronics','automotive'].map<DropdownMenuItem<String>>(
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
              ],
            ) : SizedBox(),
          ],
        ),
      );
    },);
  }
}
