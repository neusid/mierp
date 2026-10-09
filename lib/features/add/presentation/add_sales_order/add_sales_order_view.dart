import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/add/add_sales_order/input_select_sales_order_widget.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/core/widgets/input_widget.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_bloc.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_event.dart';
import 'package:mierp_apps/features/add/presentation/add_sales_order/bloc/add_sales_order_state.dart';

class AddSalesOrder extends StatefulWidget {
  const AddSalesOrder({super.key});

  @override
  State<AddSalesOrder> createState() => _AddSalesOrderState();
}

class _AddSalesOrderState extends State<AddSalesOrder> {
  final formKey = GlobalKey<FormState>();

  final companyNameC = TextEditingController();
  final purchasedDateC = TextEditingController();
  final quantityC = TextEditingController();
  
  Product? selectedProduct;
  
  void _submitData(BuildContext context) {
    if (formKey.currentState!.validate()) {
      if (selectedProduct == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a product")));
        return;
      }
      
      int quantity = int.tryParse(quantityC.text) ?? 0;
      int subtotal = selectedProduct!.unitPrice * quantity;
      int totalCost = subtotal;

      if ((selectedProduct!.discountPercent ?? 0) > 0) {
        double discountAmount = subtotal * (selectedProduct!.discountPercent! / 100);
        if (selectedProduct!.discountMax != null && discountAmount > selectedProduct!.discountMax!) {
          discountAmount = selectedProduct!.discountMax!.toDouble();
        }
        totalCost = subtotal - discountAmount.toInt();
      }
      
      final salesOrder = SalesOrder(
        id: "",
        companyName: companyNameC.text,
        financeApproved: false,
        financeApprovedDate: "",
        firstName: "", // Set via repository
        paymentStatus: false,
        productCode: selectedProduct!.productCode ?? "",
        productId: selectedProduct!.id ?? "",
        productName: selectedProduct!.productName,
        purchasedDate: purchasedDateC.text,
        quantity: int.tryParse(quantityC.text) ?? 0,
        totalPrice: totalCost,
        unitPrice: selectedProduct!.unitPrice,
        userId: "", // Set via repository
        imageProduct: selectedProduct!.imageProduct ?? "",
        discountPercent: selectedProduct!.discountPercent,
        discountMax: selectedProduct!.discountMax,
      );

      context.read<AddSalesOrderBloc>().add(AddSalesOrderSubmitted(
        salesOrder: salesOrder,
      ));
    }
  }

  void _resetForm() {
    companyNameC.clear();
    purchasedDateC.clear();
    quantityC.clear();
    setState(() {
      selectedProduct = null;
    });
  }

  @override
  void dispose() {
    companyNameC.dispose();
    purchasedDateC.dispose();
    quantityC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddSalesOrderBloc>()..add(AddSalesOrderLoadProducts()),
      child: BlocConsumer<AddSalesOrderBloc, AddSalesOrderState>(
        listener: (context, state) {
          if (state.status == AddSalesOrderStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
            _resetForm();
          } else if (state.status == AddSalesOrderStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
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
                                    InputSelectSalesOrderWidget(
                                      head: "Name Product",
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,
                                      products: state.listProduct,
                                      value: selectedProduct,
                                      onChanged: (val) {
                                        if (val != null) {
                                          setState(() {
                                            selectedProduct = val;
                                          });
                                        }
                                      },
                                    ),
                                    InputWidget(
                                      head: "Company Name",
                                      controller: companyNameC,
                                      placeholder: "placeholder",
                                      necessary: true,
                                      formKey: formKey,                                     ),
                                    if (selectedProduct != null && (selectedProduct!.discountPercent ?? 0) > 0)
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.local_offer_rounded, size: 16.w, color: const Color(0xFFB45309)),
                                            SizedBox(width: 8.w),
                                            Text(
                                              "Discount Applied: ${selectedProduct!.discountPercent}% (Max: ${(selectedProduct!.discountMax ?? 0) / 1000}rb)",
                                              style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: AppFontWeight.bold,
                                                color: const Color(0xFFB45309),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        DatePickerWidget(
                                          head: "Purchased Date",
                                          controller: purchasedDateC,
                                          placeholder: "placeholder",
                                          necessary: true,
                                          formKey: formKey,
                                          isShort: true,
                                          feature: "sales_order",
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
                                                context.pop();
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
                state.status == AddSalesOrderStatus.loading
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
