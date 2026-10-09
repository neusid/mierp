import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product_order/bloc/detail_product_order_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';

class DetailProductOrderView extends StatelessWidget {
  final String id;
  DetailProductOrderView({super.key, required this.id});

  final converDollar = ConvertDollar();

  // Helper for inline data rows
  Widget _buildDataRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: AppFontWeight.medium,
              color: const Color(0xFF64748B),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: isBold ? AppFontWeight.bold : AppFontWeight.semiBold,
              color: isBold ? const Color(0xFF0F172A) : const Color(0xFF1E293B),
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  // Ultra-Soft White Card Wrapper Helper
  Widget _buildCardWrapper({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8.w,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: AppFontWeight.semiBold,
              color: const Color(0xFF1E293B),
            ),
          ),
          Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
          child,
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String orderId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => Center(
        child: Container(
          width: 320.w,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber_rounded, color: const Color(0xFFEF4444), size: 36.w),
              ),
              SizedBox(height: 16.h),
              Text(
                "Delete Order?",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  color: const Color(0xFF0F172A),
                  fontWeight: AppFontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "This action cannot be undone. Are you sure you want to delete this order?",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: const Color(0xFF64748B),
                  fontWeight: AppFontWeight.regular,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(bottomSheetContext),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: const Color(0xFF475569),
                          fontWeight: AppFontWeight.semiBold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        context.read<DetailProductOrderBloc>().add(DetailProductOrderDeleteRequested(orderId));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: const Color(0xFFFECACA), width: 1.w),
                        ),
                        child: Center(
                          child: Text(
                            "Delete",
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              color: const Color(0xFFEF4444),
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DetailProductOrderBloc>()..add(DetailProductOrderStarted(id)),
      child: BlocConsumer<DetailProductOrderBloc, DetailProductOrderState>(
        listener: (context, state) {
          if (state.status == DetailProductOrderStatus.paySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
          } else if (state.status == DetailProductOrderStatus.deleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage)));
            Future.delayed(const Duration(seconds: 2), () {
              context.push("warehouse_main_page");
            });
          } else if (state.status == DetailProductOrderStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC), // Soft off-white background
            body: Stack(
              children: [
                Column(
                  children: [
                    // CLEAN APP BAR
                    Container(
                      width: double.infinity,
                      height: 100.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w)),
                      ),
                      padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => context.pop(),
                            borderRadius: BorderRadius.circular(12.w),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Icon(Icons.arrow_back_rounded, color: const Color(0xFF0F172A), size: 24.w),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            "Detail Order",
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: AppFontWeight.semiBold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SCROLLABLE CONTENT
                    if (state.orderProduct != null)
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 120.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Product Info Card
                              _buildCardWrapper(
                                title: "Product Information",
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56.w,
                                      height: 56.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.w),
                                        color: const Color(0xFFF8FAFC),
                                        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.5.w),
                                        image: DecorationImage(
                                          image: (state.orderProduct!.imageProduct.isEmpty)
                                              ? const AssetImage("assets/images/dummy_item.jpg")
                                              : NetworkImage(state.orderProduct!.imageProduct) as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.orderProduct!.productName,
                                            style: GoogleFonts.inter(
                                              fontSize: 14.sp,
                                              fontWeight: AppFontWeight.semiBold,
                                              color: const Color(0xFF1E293B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4.h),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                state.orderProduct!.productCode,
                                                style: GoogleFonts.inter(
                                                  fontSize: 11.sp,
                                                  fontWeight: AppFontWeight.medium,
                                                  color: const Color(0xFF64748B),
                                                ),
                                              ),
                                              // SOLID PILL BADGE
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                                decoration: BoxDecoration(
                                                  color: state.orderProduct!.financeApproved!
                                                      ? const Color(0xFF00AA13) // Gojek Green
                                                      : const Color(0xFFED2736), // Gojek Red
                                                  borderRadius: BorderRadius.circular(20.w),
                                                ),
                                                child: Text(
                                                  state.orderProduct!.financeApproved! ? "PAID" : "UNPAID",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 9.sp,
                                                    fontWeight: AppFontWeight.bold,
                                                    color: Colors.white,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Order Summary Card
                              _buildCardWrapper(
                                title: "Order Summary",
                                child: Column(
                                  children: [
                                    _buildDataRow("Order ID", state.orderProduct!.id!),
                                    _buildDataRow("Created On", state.orderProduct!.orderDate!),
                                    _buildDataRow("From", "Warehouse"),
                                    SizedBox(height: 8.h),
                                    _buildDataRow("Quantity", state.orderProduct!.quantity.toString()),
                                      _buildDataRow("Unit Price", converDollar.intToDollar(state.orderProduct!.unitPrice)),
                                      _buildDataRow("Subtotal", converDollar.intToDollar(state.orderProduct!.quantity * state.orderProduct!.unitPrice)),
                                      if (((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost) > 0)
                                        _buildDataRow("Discount", "-${converDollar.intToDollar((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost)} (${state.orderProduct!.discountPercent}%)"),
                                      Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
                                      _buildDataRow("Line Total", converDollar.intToDollar(state.orderProduct!.totalCost), isBold: true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                // BOTTOM ACTION BAR
                if (state.orderProduct != null && state.orderProduct!.financeApproved != true)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(top: BorderSide(color: const Color(0xFFE2E8F0), width: 1.w)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10.w,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: state.role == "warehouse"
                          ? // WAREHOUSE ROLE: Delete Order
                            GestureDetector(
                              onTap: () => _showDeleteConfirmation(context, state.orderProduct!.id!),
                              child: Container(
                                height: 52.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  border: Border.all(color: const Color(0xFFFECACA), width: 1.w),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Center(
                                  child: Text(
                                    "Delete Order",
                                    style: GoogleFonts.inter(
                                      fontWeight: AppFontWeight.bold,
                                      fontSize: 16.sp,
                                      color: const Color(0xFFEF4444),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : // FINANCE ROLE: Pay Invoice
                            GestureDetector(
                              onTap: () {
                                context.read<DetailProductOrderBloc>().add(
                                  DetailProductOrderPayRequested(
                                    state.orderProduct!.id!,
                                    state.orderProduct!.productId,
                                    state.orderProduct!.quantity,
                                  ),
                                );
                              },
                              child: Container(
                                height: 52.h,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF3B82F6), Color(0xFF6D28D9)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                                child: Center(
                                  child: Text(
                                    "Pay Invoice",
                                    style: GoogleFonts.inter(
                                      fontWeight: AppFontWeight.bold,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),

                // LOADING OVERLAY
                if (state.status == DetailProductOrderStatus.loading || state.orderProduct == null)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: Colors.white,
                        size: 70.w,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}