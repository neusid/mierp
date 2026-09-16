import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/controller/move_page_controller.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/loading_controller.dart';
import 'package:mierp_apps/core/widgets/add/add_unit/input_selected_add_unit_widget.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/core/widgets/input_widget.dart';
import 'package:mierp_apps/features/add/presentation/add_unit/add_unit_view_model.dart';

class AddUnitView extends StatelessWidget {
  AddUnitView({super.key});

  final movePageC = Get.find<MovePageController>();
  final loadingC = Get.find<LoadingController>();
  final addUnitVM = Get.find<AddUnitViewModel>();
  final formKey = GlobalKey<FormState>();

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
                        spacing: 16.h,
                        children: [
                          InputWidget(
                            head: "Code Product",
                            controller: addUnitVM.productCodeC,
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                          ),
                          InputWidget(
                            head: "Name Product",
                            controller: addUnitVM.nameProductC,
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                          ),
                          InputSelectAddUnitWidget(
                            head: "Category Product",
                            placeholder: "placeholder",
                            necessary: true,
                            formKey: formKey,
                          ),
                          DatePickerWidget(
                            head: "Created On",
                            controller: addUnitVM.createdOnC,
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
                                controller: addUnitVM.quantityC,
                                placeholder: "placeholder",
                                iconAsset: "box.svg",
                                necessary: true,
                                formKey: formKey,
                              ),
                              InputShortWidget(
                                head: "Unit Price",
                                controller: addUnitVM.unitPriceC,
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
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();

                                      XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery,
                                      );

                                      addUnitVM.imageFile.value = image;

                                      print(image);
                                    },
                                    child: Ink(
                                      width: 331.w,
                                      height: 183.h,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          10.w,
                                        ),
                                      ),
                                      child: Obx(
                                        () => DottedBorder(
                                          options:
                                              RoundedRectDottedBorderOptions(
                                                radius: Radius.circular(10.w),
                                                color: AppColors.coolGray,
                                                dashPattern: [10, 10],
                                                strokeWidth: 2.w,
                                              ),
                                          child: Center(
                                            child:
                                                addUnitVM.imageFile.value !=
                                                    null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10.w,
                                                        ),
                                                    child: Image.file(
                                                      File(
                                                        addUnitVM
                                                            .imageFile
                                                            .value!
                                                            .path,
                                                      ),
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  )
                                                : Image.asset(
                                                    "assets/images/galery_add.png",
                                                    width: 48.w,
                                                    height: 48.h,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white54, Colors.white],
                      begin: AlignmentGeometry.topCenter,
                      end: AlignmentGeometry.bottomCenter,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 55.w,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: () {
                            addUnitVM.resetControllerInput();
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
                              addUnitVM.requestPostDataProduct();
                            }
                          },
                          child: Text(
                            "Kirim",
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
                                      Get.back();
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
              () => addUnitVM.isLoading.value == true
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
