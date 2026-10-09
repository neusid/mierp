import re

# Rewrite AddProductOrderView

code = """import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as getx;
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/product_order.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/add/add_warehouse_order/input_select_product_order_widget.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_event.dart';
import 'package:mierp_apps/features/add/presentation/add_product_order/bloc/add_product_order_state.dart';

class AddProductOrderView extends StatefulWidget {
  const AddProductOrderView({super.key});

  @override
  State<AddProductOrderView> createState() => _AddProductOrderViewState();
}

class _AddProductOrderViewState extends State<AddProductOrderView> {
  final formKey = GlobalKey<FormState>();

  final orderDateC = TextEditingController();
  final quantityC = TextEditingController();
  
  String selectedProductName = "";
  
  void _submitData(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final productOrder = ProductOrder(
        id: "", // Assign dynamically in API if necessary
        orderDate: orderDateC.text,
        productName: selectedProductName,
        quantity: int.tryParse(quantityC.text) ?? 0,
      );

      context.read<AddProductOrderBloc>().add(AddProductOrderSubmitted(
        productOrder: productOrder,
      ));
    }
  }

  void _resetForm() {
    orderDateC.clear();
    quantityC.clear();
    setState(() {
      selectedProductName = "";
    });
  }

  @override
  void dispose() {
    orderDateC.dispose();
    quantityC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddProductOrderBloc>(),
      child: BlocConsumer<AddProductOrderBloc, AddProductOrderState>(
        listener: (context, state) {
          if (state.status == AddProductOrderStatus.success) {
            getx.Get.snackbar("Success", state.successMessage);
            _resetForm();
          } else if (state.status == AddProductOrderStatus.failure) {
            getx.Get.snackbar("Failed", state.errorMessage);
          }
        },
        builder: (context, state) {
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
                              SizedBox(height: 145.h),
                              Container(
                                width: 322.w,
                                child: Column(
                                  spacing: 16.h,
                                  children: [
                                    InputSelectProductOrderWidget(
                                      head: "Name Product",
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                      value: selectedProductName,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            selectedProductName = val;
                                          });
                                        }
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DatePickerWidget(
                                          head: "Order Date",
                                          controller: orderDateC,
                                          placeholder: "placeholder",
                                          necessary: true,
                                          formKey: formKey,
                                          isShort: true,
                                          feature: "product_order",
                                        ),
                                        InputShortWidget(
                                          head: "Quantity",
                                          controller: quantityC,
                                          placeholder: "placeholder",
                                          iconAsset: "box.svg",
                                          necessary: true,
                                          formKey: formKey,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 140.h)
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
                                    end: AlignmentGeometry.bottomCenter)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 55.w,
                                  height: 55.h,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _resetForm();
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
                                      _submitData(context);
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                getx.Get.back();
                                              },
                                              child: Icon(Icons.close, size: 24.w),
                                            ),
                                            SizedBox(
                                              width: 19.w,
                                            ),
                                            Text(
                                              "Back To Summary",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16.sp,
                                                  fontWeight: AppFontWeight.medium),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                state.status == AddProductOrderStatus.loading
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
              ],
            ),
          );
        },
      ),
    );
  }
}
"""

with open(r"d:\Project\Flutter\mierp\lib\features\add\presentation\add_product_order\add_product_order_view.dart", "w", encoding="utf-8") as f:
    f.write(code)

print("Add product order view rewritten")
