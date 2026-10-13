import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mierp_apps/core/di/injection_container.dart';
import 'package:mierp_apps/features/detail/presentation/detail_product_order/bloc/detail_product_order_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:mierp_apps/core/utils/convert_dollar.dart';
import 'package:mierp_apps/core/widgets/custom_top_snackbar.dart';
import 'package:mierp_apps/core/widgets/modal_pay_confirmation.dart';
import 'package:mierp_apps/features/payment/presentation/payment_success_view.dart';

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

  void _showRejectDialog(BuildContext context, String orderId) {
    final reasonController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
        ),
        child: Center(
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
                  decoration: const BoxDecoration(
                    color: Color(0xFFFEF2F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.cancel_outlined, color: const Color(0xFFDC2626), size: 36.w),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Tolak Tagihan Invoice?",
                  style: GoogleFonts.inter(
                    fontSize: 16.sp,
                    color: const Color(0xFF0F172A),
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Berikan alasan penolakan agar tim gudang dapat mengetahui kendala tagihan ini.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF64748B),
                    fontWeight: AppFontWeight.regular,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Contoh: Harga tidak sesuai atau pesanan duplikat",
                    hintStyle: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.w),
                      borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  ),
                  style: GoogleFonts.inter(fontSize: 12.sp, color: const Color(0xFF0F172A)),
                ),
                SizedBox(height: 20.h),
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
                          "Batal",
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
                          final reason = reasonController.text.trim();
                          Navigator.pop(bottomSheetContext);
                          context.read<DetailProductOrderBloc>().add(
                            DetailProductOrderRejectRequested(orderId, reason.isNotEmpty ? reason : "Ditolak oleh Finance"),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626),
                            borderRadius: BorderRadius.circular(12.w),
                          ),
                          child: Center(
                            child: Text(
                              "Tolak",
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                color: Colors.white,
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
            final order = state.orderProduct;
            if (order != null) {
              PaymentSuccessView.open(
                context,
                invoiceId: order.id ?? id,
                productName: order.productName,
                quantity: order.quantity,
                amount: converDollar.intToDollar(order.totalCost),
                requestedBy: order.firstName,
                paymentType: "Warehouse Order",
              ).then((result) {
                if (context.mounted && result == true) {
                  context.read<DetailProductOrderBloc>().add(DetailProductOrderStarted(id));
                }
              });
            } else {
              CustomTopSnackbar.success(context, state.successMessage);
            }
          } else if (state.status == DetailProductOrderStatus.rejectSuccess) {
            CustomTopSnackbar.success(
              context,
              state.successMessage,
              onDismissed: () {
                if (context.mounted) {
                  context.pop(true);
                }
              },
            );
          } else if (state.status == DetailProductOrderStatus.deleteSuccess) {
            CustomTopSnackbar.success(
              context,
              state.successMessage,
              onDismissed: () {
                if (context.mounted) {
                  context.push("warehouse_main_page");
                }
              },
            );
          } else if (state.status == DetailProductOrderStatus.failure) {
            CustomTopSnackbar.error(context, state.errorMessage);
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
                            onTap: () => context.pop(state.orderProduct?.isRejected == true || state.orderProduct?.financeApproved == true),
                            borderRadius: BorderRadius.circular(12.w),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12.w),
                              ),
                              child: Icon(Icons.arrow_back_ios_new_rounded, color: const Color(0xFF0F172A), size: 24.w),
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
                              // REJECTION BANNER (if rejected)
                              if (state.orderProduct!.isRejected == true)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(14.w),
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(12.w),
                                    border: Border.all(color: const Color(0xFFFECACA), width: 1.w),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.cancel_rounded, color: const Color(0xFFDC2626), size: 22.w),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Invoice Ditolak oleh Finance",
                                              style: GoogleFonts.inter(
                                                fontSize: 13.sp,
                                                fontWeight: AppFontWeight.bold,
                                                color: const Color(0xFF991B1B),
                                              ),
                                            ),
                                            if ((state.orderProduct!.rejectionReason ?? '').isNotEmpty) ...[
                                              SizedBox(height: 4.h),
                                              Text(
                                                "Alasan: ${state.orderProduct!.rejectionReason}",
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.sp,
                                                  fontWeight: AppFontWeight.medium,
                                                  color: const Color(0xFFB91C1C),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

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
                                                  color: state.orderProduct!.isRejected == true
                                                      ? const Color(0xFFDC2626) // Red 600
                                                      : state.orderProduct!.financeApproved!
                                                          ? const Color(0xFF00AA13) // Gojek Green
                                                          : const Color(0xFFED2736), // Gojek Red
                                                  borderRadius: BorderRadius.circular(20.w),
                                                ),
                                                child: Text(
                                                  state.orderProduct!.isRejected == true
                                                      ? "REJECTED"
                                                      : (state.orderProduct!.financeApproved ?? false) ? "PAID" : "UNPAID",
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
                                    _buildDataRow("Order ID", state.orderProduct!.id ?? id),
                                    _buildDataRow("Created On", state.orderProduct!.orderDate ?? "-"),
                                    _buildDataRow("From", "Warehouse"),
                                    SizedBox(height: 8.h),
                                    _buildDataRow("Quantity", state.orderProduct!.quantity.toString()),
                                      _buildDataRow("Unit Price", converDollar.intToDollar(state.orderProduct!.unitPrice)),
                                      _buildDataRow("Subtotal", converDollar.intToDollar(state.orderProduct!.quantity * state.orderProduct!.unitPrice)),
                                      if (((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost) > 0)
                                        _buildDataRow("Discount", "-${converDollar.intToDollar((state.orderProduct!.quantity * state.orderProduct!.unitPrice) - state.orderProduct!.totalCost)} (${state.orderProduct!.discountPercent ?? 0}%)"),
                                      Divider(color: const Color(0xFFF1F5F9), height: 24.h, thickness: 1.w),
                                      _buildDataRow("Line Total", converDollar.intToDollar(state.orderProduct!.totalCost), isBold: true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (state.status == DetailProductOrderStatus.failure)
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline_rounded, size: 54.w, color: const Color(0xFFEF4444)),
                                SizedBox(height: 12.h),
                                Text(
                                  "Gagal Memuat Detail Order",
                                  style: GoogleFonts.inter(
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  state.errorMessage.isNotEmpty ? state.errorMessage : "Koneksi bermasalah atau data order tidak ditemukan.",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<DetailProductOrderBloc>().add(DetailProductOrderStarted(id));
                                  },
                                  icon: Icon(Icons.refresh_rounded, size: 18.w, color: Colors.white),
                                  label: Text(
                                    "Coba Lagi",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: AppFontWeight.semiBold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0F172A),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
                                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // BOTTOM ACTION BAR
                if (state.orderProduct != null &&
                    state.orderProduct!.financeApproved != true &&
                    state.orderProduct!.isRejected != true)
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
                      child: (state.role ?? "").toLowerCase() == "finance"
                          ? // FINANCE ROLE: Reject & Pay Dual Buttons
                            Row(
                              children: [
                                Expanded(
                                  flex: 35,
                                  child: GestureDetector(
                                    onTap: () => _showRejectDialog(context, state.orderProduct!.id ?? id),
                                    child: Container(
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEF2F2),
                                        border: Border.all(color: const Color(0xFFFECACA), width: 1.w),
                                        borderRadius: BorderRadius.circular(10.w),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Reject",
                                          style: GoogleFonts.inter(
                                            fontWeight: AppFontWeight.bold,
                                            fontSize: 14.sp,
                                            color: const Color(0xFFDC2626),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  flex: 65,
                                  child: GestureDetector(
                                    onTap: () {
                                      showPayConfirmationModal(
                                        context: context,
                                        orderId: state.orderProduct!.id ?? "",
                                        productName: state.orderProduct!.productName,
                                        productCode: state.orderProduct!.productCode,
                                        imageProduct: state.orderProduct!.imageProduct,
                                        quantity: state.orderProduct!.quantity,
                                        unitPrice: state.orderProduct!.unitPrice,
                                        totalCost: state.orderProduct!.totalCost,
                                        discountPercent: state.orderProduct!.discountPercent,
                                        discountMax: state.orderProduct!.discountMax,
                                        requestedBy: state.orderProduct!.firstName,
                                        orderDate: state.orderProduct!.orderDate,
                                        onConfirm: () {
                                          context.read<DetailProductOrderBloc>().add(
                                            DetailProductOrderPayRequested(
                                              state.orderProduct!.id ?? id,
                                              state.orderProduct!.productId,
                                              state.orderProduct!.quantity,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                        gradient: AppColors.premiumDarkGradient,
                                        borderRadius: BorderRadius.circular(10.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.premiumDarkSolid.withValues(alpha: 0.25),
                                            blurRadius: 8.w,
                                            offset: Offset(0, 4.w),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Pay Invoice",
                                          style: GoogleFonts.inter(
                                            fontWeight: AppFontWeight.bold,
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : // WAREHOUSE ROLE: Delete Order
                            GestureDetector(
                              onTap: () => _showDeleteConfirmation(context, state.orderProduct!.id ?? id),
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
                            ),
                    ),
                  ),

                // LOADING OVERLAY
                if (state.status == DetailProductOrderStatus.loading)
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