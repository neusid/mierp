import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/controller_widget/input_widget_controller.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/add_product_order_view_model.dart';

class InputSelectProductOrderWidget extends StatelessWidget {
  InputSelectProductOrderWidget({super.key, required this.head, required this.placeholder, required this.necessary, required this.formKey});

  final head, placeholder, necessary, formKey;
  final inputWidgetC = Get.put(InputWidgetController(), tag: UniqueKey().toString());
  final addProductOrderVM = Get.put(AddProductOrderViewModel());
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
                        height: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  icon: Icon(Icons.arrow_drop_down),
                  value: addProductOrderVM.selectedProduct.value,
                  onChanged: (value) {
                    addProductOrderVM.selectedProduct.value = value!;
                    print(value.id);
                  },
                  items: addProductOrderVM.listProduct.value.map<DropdownMenuItem<Product>>(
                          (Product? value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value!.productName,
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: AppFontWeight.regular,
                              height: 1.0,
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
