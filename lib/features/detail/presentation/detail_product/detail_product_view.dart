import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/detail/input_select_update_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/core/widgets/input_widget.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product/detail_product_view_model.dart';

class DetailProductView extends StatelessWidget {
  DetailProductView({super.key});

  final detailProductViewVM = Get.find<DetailProductViewModel>();
  final movePageC = Get.find<MovePageController>();
  final loadingC = Get.find<LoadingController>();
  final formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.bgColor,
      body: Form(
        key: formKey,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 145.h),
                    Container(
                      width: 322.w,
                      child: Column(
                        spacing: 16.w,
                        children: [
                          InputWidget(
                            head: "Code Product",
                            controller: detailProductViewVM.productCodeC,
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                          ),
                          InputWidget(
                            head: "Name Product",
                            controller: detailProductViewVM.nameProductC,
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                          ),
                          InputSelectUpdateWidget(
                            head: "Category Product",
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                          ),
                          DatePickerWidget(
                            head: "Created On",
                            controller: detailProductViewVM.createdOnC,
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                            isShort: false,
                            feature: "add_unit",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InputShortWidget(
                                head: "Quantity",
                                controller: detailProductViewVM.quantityC,
                                placeholder: "placeholder",
                                iconAsset: "box.svg",
                                necessary: true,
                                formKey: formKey,
                              ),
                              InputShortWidget(
                                head: "Unit Price",
                                controller: detailProductViewVM.unitPriceC,
                                placeholder: "placeholder",
                                iconAsset: "price_tag.svg",
                                necessary: true,
                                formKey: formKey,
                              ),
                            ],
                          ),
                          Container(
                            width: 333.w,
                            height: 219.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "*",
                                      style: GoogleFonts.roboto(
                                        color: Colors.red,
                                        fontSize: 14.sp,
                                        fontWeight: AppFontWeight.medium,
                                      ),
                                    ),
                                    Text(
                                      "Image Product",
                                      style: GoogleFonts.roboto(
                                        fontSize: 13.sp,
                                        color: AppColors.grayTitle,
                                        fontWeight: AppFontWeight.regular,
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(() {
                                  return Container(
                                    width: 331.w,
                                    height: 183.h,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            detailProductViewVM
                                                .imageProduct
                                                .value
                                                .isEmpty
                                            ? AssetImage(
                                                "assets/images/dummy_item.jpg",
                                              )
                                            : NetworkImage(
                                                detailProductViewVM
                                                    .imageProduct
                                                    .value,
                                              ),
                                      ),
                                      borderRadius: BorderRadius.circular(10.w),
                                    ),
                                    child: DottedBorder(
                                      options: RoundedRectDottedBorderOptions(
                                        radius: Radius.circular(10.w),
                                        color: AppColors.coolGray,
                                        dashPattern: [10, 10],
                                        strokeWidth: 2.w,
                                      ),
                                      child: Center(child: Column()),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(height: 140.h),
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
                  color: Colors.white60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 55.w,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: () {
                            detailProductViewVM.delete();
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
                              borderRadius: BorderRadius.circular(10.w),
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
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              detailProductViewVM.updateSingleProduct();
                            }
                          },
                          child: Text(
                            "Update",
                            style: GoogleFonts.roboto(
                              fontWeight: AppFontWeight.regular,
                              fontSize: 20.sp,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
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
                            ),
                          ],
                          color: Colors.white,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 63.h),
                            Container(
                              padding: EdgeInsets.only(left: 30.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      detailProductViewVM.moveBack();
                                    },
                                    child: Icon(Icons.close, size: 24.w),
                                  ),
                                  SizedBox(width: 19.w),
                                  Text(
                                    "Back To Summary",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: AppFontWeight.medium,
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
            Obx(
              () => detailProductViewVM.isLoading.value
                  ? Container(
                      color: Colors.black26,
                      child: Center(
                        child: LoadingAnimationWidget.stretchedDots(
                          color: AppColors.softWhite,
                          size: 70.w,
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
