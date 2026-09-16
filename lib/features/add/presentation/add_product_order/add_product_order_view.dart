import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/add/add_warehouse_order/input_select_product_order_widget.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/add_product_order_view_model.dart';

class AddProductOrderView extends StatelessWidget {
  AddProductOrderView({super.key});

  final movePageC = Get.find<MovePageController>();
  final loadingC = Get.find<LoadingController>();
  final addProductOrderC = Get.put(AddProductOrderViewModel());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 145.h,),
                        Container(
                          width: 322.w,
                          child: Column(
                            spacing: 16.h,
                            children: [
                              InputSelectProductOrderWidget(head: "Name Product", placeholder: "placeholder", necessary: true, formKey: formKey),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  DatePickerWidget(head: "Order Date", controller: addProductOrderC.orderDateC, placeholder: "placeholder", necessary: true, formKey: formKey, isShort: true, feature: "product_order",),
                                  InputShortWidget(head: "Quantity", controller: addProductOrderC.quantityC, placeholder: "placeholder", iconAsset: "box.svg", necessary: true, formKey: formKey),
                                ],
                              ),
                              SizedBox(height: 140.h,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 393.w,
                      height: 106.h,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.white54, Colors.white], begin: AlignmentGeometry.topCenter, end: AlignmentGeometry.bottomCenter)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 55.w,
                            height: 55.h,
                            child: ElevatedButton(
                              onPressed: () {
                                addProductOrderC.resetControllerInput();
                              },
                              child: SvgPicture.asset(
                                "assets/icons/delete.svg",
                                width: 32.w,
                                height: 32.h,
                                fit: BoxFit.contain,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w)
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 261.w,
                            height: 55.h,
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate() && addProductOrderC.selectedProduct.value != null) {
                                  addProductOrderC.addProductOrder();
                                }
                              },
                              child: Text(
                                "Kirim",
                                style: GoogleFonts.roboto(
                                    fontWeight: AppFontWeight.regular,
                                    fontSize: 20.sp,
                                    color: Colors.white
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.w)
                                ),
                                backgroundColor: AppColors.neonGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 112.h,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 4),
                                  blurRadius: 14.2.w,
                                  spreadRadius: 0,
                                  color: AppColors.appBarShadow,
                                )
                              ],
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 63.h,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 30.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: 24.w,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 19.w,
                                      ),
                                      Text(
                                        "Back To Summary",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16.sp,
                                            fontWeight: AppFontWeight.medium
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Obx(()=>loadingC.isLoading.value? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w,))):SizedBox(),)
              ],
            ),
          ),
          Obx(()=>loadingC.isLoading.value? Container(color: Colors.black26, child: Center(child: LoadingAnimationWidget.stretchedDots(color: AppColors.softWhite, size: 70.w,))):SizedBox(),)
        ],
      ),
    );
  }
}
