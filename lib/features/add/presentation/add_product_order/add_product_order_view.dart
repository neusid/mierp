import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/widgets/add/add_warehouse_order/input_select_product_order_widget.dart';
import 'package:mierp_apps/core/widgets/date_picker_widget.dart';
import 'package:mierp_apps/core/widgets/input_short_widget.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
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
      
      final productOrder = OrderProduct(
        id: "",
        financeApproved: false,
        financeApprovedDate: null,
        orderDate: orderDateC.text,
        productId: selectedProduct!.id ?? "",
        productCode: selectedProduct!.productCode,
        productName: selectedProduct!.productName,
        quantity: int.tryParse(quantityC.text) ?? 0,
        totalCost: totalCost,
        unitPrice: selectedProduct!.unitPrice,
        userId: "", // Set via repository
        firstName: "", // Set via repository
        imageProduct: selectedProduct!.imageProduct ?? "",
        discountPercent: selectedProduct!.discountPercent,
        discountMax: selectedProduct!.discountMax,
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
      selectedProduct = null;
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
      create: (context) => sl<AddProductOrderBloc>()..add(AddProductOrderLoadProducts()),
      child: BlocConsumer<AddProductOrderBloc, AddProductOrderState>(
        listener: (context, state) {
          if (state.status == AddProductOrderStatus.success) {
            CustomTopSnackbar.show(context, "Berhasil menyimpan data!", isError: false);
            context.pop();
          } else if (state.status == AddProductOrderStatus.failure) {
            CustomTopSnackbar.show(context, state.errorMessage, isError: true);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.bgColor,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: false,
              leadingWidth: 68.w,
              leading: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: InkWell(
                    onTap: () => context.pop(),
                    borderRadius: BorderRadius.circular(12.w),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9), // Light gray background
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      child: Icon(Icons.arrow_back_rounded, color: AppColors.charcoal, size: 24.w),
                    ),
                  ),
                ),
              ),
              title: Text(
                "Add Product Order",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: AppFontWeight.bold,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Container(
                  color: const Color(0xFFE2E8F0),
                  height: 1.0,
                ),
              ),
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                  child: Column(
                    children: [
                      // The "Selimut" Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(color: Colors.white, width: 1.5.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10.w,
                              offset: Offset(0, 4.h),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InputSelectProductOrderWidget(
                                head: "Name Product",
                                placeholder: "Select Product",
                                necessary: true,
                                formKey: formKey,
                                products: state.listProduct,
                                value: selectedProduct,
                                width: double.infinity,
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() {
                                      selectedProduct = val;
                                    });
                                  }
                                },
                              ),
                              SizedBox(height: 16.h),
                              if (selectedProduct != null && (selectedProduct!.discountPercent ?? 0) > 0)
                                Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF3C7),
                                    borderRadius: BorderRadius.circular(8.w),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.local_offer_rounded, size: 16.w, color: const Color(0xFFB45309)),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Text(
                                          "Discount Applied: ${selectedProduct!.discountPercent}% (Max: ${(selectedProduct!.discountMax ?? 0) / 1000}rb)",
                                          style: GoogleFonts.inter(
                                            fontSize: 12.sp,
                                            fontWeight: AppFontWeight.bold,
                                            color: const Color(0xFFB45309),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: DatePickerWidget(
                                      head: "Order Date",
                                      controller: orderDateC,
                                      placeholder: "Select Date",
                                      necessary: true,
                                      formKey: formKey,
                                      width: double.infinity,
                                    ),
                                  ),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                    child: InputShortWidget(
                                      head: "Quantity",
                                      controller: quantityC,
                                      placeholder: "0",
                                      iconAsset: "box.svg",
                                      necessary: true,
                                      formKey: formKey,
                                      width: double.infinity,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 100.h), // Extra padding for safe area
                    ],
                  ),
                ),
                if (state.status == AddProductOrderStatus.loading)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: AppColors.softWhite,
                        size: 70.w,
                      ),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10.w,
                    offset: Offset(0, -4.h),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5.w),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.refresh_rounded, color: const Color(0xFF64748B)),
                        onPressed: _resetForm,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Container(
                        height: 52.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(10.w),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withValues(alpha: 0.2),
                              blurRadius: 8.w,
                              offset: Offset(0, 4.w),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () => _submitData(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                          ),
                          child: Text(
                            "Kirim",
                            style: GoogleFonts.inter(
                              fontWeight: AppFontWeight.semiBold,
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}