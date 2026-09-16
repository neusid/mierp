import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';

class InputSelectAddUnitWidget extends StatelessWidget {
  InputSelectAddUnitWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey});

  final head, placeholder, necessary, formKey;
  final inputWidgetC = Get.put(InputWidgetController(), tag: UniqueKey().toString());
  final addUnitVM = Get.find<AddUnitViewModel>();
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
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(6.w),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.5.w),
                  icon: Icon(Icons.arrow_drop_down),
                  value: addUnitVM.categoryProductC.value,
                  onChanged: (value) {
                    addUnitVM.categoryProductC.value = value!;
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
