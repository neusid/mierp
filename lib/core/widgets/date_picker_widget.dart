import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/add_product_order_view_model.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/add_sales_order_view_model.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';
import 'package:mierp_apps/features/login/presentation/login_view_model.dart';

class DatePickerWidget extends StatelessWidget {
  DatePickerWidget({super.key, required this.head, required this.controller, required this.placeholder, required this.necessary, required this.formKey, required this.isShort, required this.feature});

  final head, controller, placeholder, necessary, formKey, isShort, feature;
  final inputWidgetC = Get.put(InputWidgetController(), tag: UniqueKey().toString());
  RxBool hasError = false.obs;
  RxString dataError = "".obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: isShort? 145.w: 335.w,
        height: !hasError.value? 75.w:90.w,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              // height: 45.w,
              height: 45.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.w),
                boxShadow: [
                  BoxShadow(color: Colors.white, spreadRadius: 2),
                  BoxShadow(
                    color: AppColors.shadowBox,
                    spreadRadius: 0.w,
                    blurRadius: 9.w,
                  )
                ],
              ),
              child: TextFormField(
                controller: controller,
                readOnly: true,
                focusNode: inputWidgetC.focusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    hasError.value = true;
                    dataError.value = "Wajib diisi";
                    return null;
                  }
                },
                onTap: () {
                  if(isShort){
                    if(feature == "sales_order"){
                      final addSalesOrderVM = Get.find<AddSalesOrderViewModel>();
                      addSalesOrderVM.showDate(context);
                    } else {
                      final addProductOrder = Get.find<AddProductOrderViewModel>();
                      addProductOrder.showDate(context);
                    }
                  } else {
                    final addUnitVM = Get.find<AddUnitViewModel>();
                    addUnitVM.showDate(context);
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
                  hintText: "$head",
                  hintStyle: GoogleFonts.inter(
                    color: AppColors.greyPlacholder,
                    fontSize: 13.sp,
                    fontWeight: AppFontWeight.regular,
                  ),
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
              ],
            ) : SizedBox(),
          ],
        ),
      );
    });
  }
}

