import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';
import 'package:dotted_line/dotted_line.dart';

class PaymentSuccessView extends StatefulWidget {
  final String invoiceId;
  final String productName;
  final int quantity;
  final String amount;
  final DateTime transactionDate;
  final String paymentType;
  final String? requestedBy;

  const PaymentSuccessView({
    super.key,
    required this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.transactionDate,
    this.paymentType = "Warehouse Order",
    this.requestedBy,
  });

  /// Static helper to navigate to this page with true/false return value for auto-refresh
  static Future<bool?> open(
    BuildContext context, {
    required String invoiceId,
    required String productName,
    required int quantity,
    required String amount,
    DateTime? transactionDate,
    String? paymentType,
    String? requestedBy,
  }) {
    return Navigator.of(context, rootNavigator: true).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaymentSuccessView(
          invoiceId: invoiceId,
          productName: productName,
          quantity: quantity,
          amount: amount,
          transactionDate: transactionDate ?? DateTime.now(),
          paymentType: paymentType ?? "Warehouse Order",
          requestedBy: requestedBy,
        ),
      ),
    );
  }

  @override
  State<PaymentSuccessView> createState() => _PaymentSuccessViewState();
}

class _PaymentSuccessViewState extends State<PaymentSuccessView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    HapticFeedback.mediumImpact();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final formattedDate = dateFormat.format(widget.transactionDate);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 12.w),

                      // 1. ANIMASI LOTTIE CENTANG SUKSES DENGAN CONFETTI
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: SizedBox(
                          width: 170.w,
                          height: 170.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Lottie.asset(
                                'assets/lottie/success_celebration.json',
                                repeat: false,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => _buildFallbackCheckmark(),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 12.w),

                      // 2. STATUS TITLE & SUBTITLE
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              "Pembayaran Berhasil!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 22.w,
                                fontWeight: AppFontWeight.bold,
                                color: const Color(0xFF0F172A),
                                letterSpacing: -0.3,
                              ),
                            ),
                            SizedBox(height: 6.w),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Text(
                                "Transaksi invoice Anda telah selesai dan diverifikasi oleh divisi Finance.",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 13.w,
                                  fontWeight: AppFontWeight.regular,
                                  color: const Color(0xFF64748B),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.w),

                      // 3. FINTECH RECEIPT CARD
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.w),
                            border: Border.all(color: const Color(0xFFF1F5F9), width: 1.w),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                                blurRadius: 20.w,
                                offset: Offset(0, 8.w),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Header Receipt: Nominal Besar
                              Container(
                                padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 16.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.w),
                                    topRight: Radius.circular(20.w),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "TOTAL DIBAYARKAN",
                                      style: GoogleFonts.inter(
                                        fontSize: 11.w,
                                        fontWeight: AppFontWeight.bold,
                                        letterSpacing: 1.1,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    SizedBox(height: 6.w),
                                    Text(
                                      widget.amount,
                                      style: GoogleFonts.inter(
                                        fontSize: 26.w,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    SizedBox(height: 8.w),
                                    // Solid Gojek-style Approval Badge
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        borderRadius: BorderRadius.circular(100.w),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF10B981).withValues(alpha: 0.3),
                                            blurRadius: 8.w,
                                            offset: Offset(0, 2.w),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.check_circle_rounded, color: Colors.white, size: 14.w),
                                          SizedBox(width: 5.w),
                                          Text(
                                            "Finance Approved",
                                            style: GoogleFonts.inter(
                                              fontSize: 11.w,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Garis Tiket Dotted Separator
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                child: const DottedLine(
                                  dashColor: Color(0xFFCBD5E1),
                                  dashLength: 6,
                                  dashGapLength: 4,
                                  lineThickness: 1,
                                ),
                              ),

                              // Detail Item & Metadata Transaksi
                              Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  children: [
                                    _buildReceiptRow("No. Invoice", "#${widget.invoiceId}", isBold: true),
                                    SizedBox(height: 12.w),
                                    _buildReceiptRow("Nama Produk", widget.productName),
                                    SizedBox(height: 12.w),
                                    _buildReceiptRow("Jumlah (Qty)", "${widget.quantity} Unit"),
                                    SizedBox(height: 12.w),
                                    _buildReceiptRow("Tipe Transaksi", widget.paymentType),
                                    if (widget.requestedBy != null && widget.requestedBy!.isNotEmpty) ...[
                                      SizedBox(height: 12.w),
                                      _buildReceiptRow("Diminta Oleh", widget.requestedBy!),
                                    ],
                                    SizedBox(height: 12.w),
                                    _buildReceiptRow("Waktu Bayar", formattedDate),
                                    SizedBox(height: 12.w),
                                    _buildReceiptRow(
                                      "Status Akun",
                                      "Lunas (Paid)",
                                      valueColor: const Color(0xFF10B981),
                                      isBold: true,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20.w),
                    ],
                  ),
                ),
              ),

              // 4. ACTION BUTTONS (BOTTOM PINNED)
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 14.w, 20.w, 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: const Color(0xFFF1F5F9), width: 1.w)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10.w,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Utama: Kembali (Auto-refresh state)
                    InkWell(
                      borderRadius: BorderRadius.circular(12.w),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.of(context).pop(true);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48.w,
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(12.w),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.premiumDarkSolid.withValues(alpha: 0.25),
                              blurRadius: 12.w,
                              offset: Offset(0, 4.w),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Kembali",
                            style: GoogleFonts.inter(
                              fontSize: 14.w,
                              fontWeight: AppFontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.w),

                    // Tombol Sekunder: Kembali ke Dashboard
                    InkWell(
                      borderRadius: BorderRadius.circular(12.w),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.go('/finance_main_page');
                      },
                      child: Container(
                        width: double.infinity,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.w),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                        ),
                        child: Center(
                          child: Text(
                            "Kembali ke Dashboard",
                            style: GoogleFonts.inter(
                              fontSize: 13.w,
                              fontWeight: AppFontWeight.semiBold,
                              color: const Color(0xFF475569),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackCheckmark() {
    return Container(
      width: 100.w,
      height: 100.w,
      decoration: BoxDecoration(
        color: const Color(0xFF10B981),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withValues(alpha: 0.35),
            blurRadius: 20.w,
            offset: Offset(0, 8.w),
          ),
        ],
      ),
      child: Center(
        child: Icon(Icons.check_rounded, color: Colors.white, size: 54.w),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.5.w,
            fontWeight: AppFontWeight.medium,
            color: const Color(0xFF64748B),
          ),
        ),
        SizedBox(width: 12.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12.5.w,
              fontWeight: isBold ? AppFontWeight.bold : AppFontWeight.semiBold,
              color: valueColor ?? const Color(0xFF1E293B),
            ),
          ),
        ),
      ],
    );
  }
}
