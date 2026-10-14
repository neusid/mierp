import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/services/export_service.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';
import 'package:mierp_apps/core/theme/app_font_weight.dart';

class ModalExportSheet extends StatefulWidget {
  final String reportTitle;
  final String subtitle;
  final Future<void> Function(ExportFormat format) onExport;

  const ModalExportSheet({
    super.key,
    required this.reportTitle,
    this.subtitle = "Pilih format dokumen laporan yang ingin diunduh atau dibagikan",
    required this.onExport,
  });

  static Future<void> show(
    BuildContext context, {
    required String reportTitle,
    String? subtitle,
    required Future<void> Function(ExportFormat format) onExport,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ModalExportSheet(
        reportTitle: reportTitle,
        subtitle: subtitle ?? "Pilih format dokumen laporan yang ingin diunduh atau dibagikan",
        onExport: onExport,
      ),
    );
  }

  @override
  State<ModalExportSheet> createState() => _ModalExportSheetState();
}

class _ModalExportSheetState extends State<ModalExportSheet> {
  ExportFormat _selectedFormat = ExportFormat.pdf;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 28.r,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. DRAG HANDLE
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),

              // 2. HEADER (Obsidian & Ungu signature badge)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: AppColors.premiumDarkGradient,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                          blurRadius: 8.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.ios_share_rounded,
                        color: Colors.white,
                        size: 22.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.reportTitle,
                          style: GoogleFonts.inter(
                            fontSize: 16.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          widget.subtitle,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            color: const Color(0xFF64748B),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // 3. SECTION LABEL
              Text(
                "PILIH FORMAT DOKUMEN",
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF475569),
                  letterSpacing: 0.6,
                ),
              ),
              SizedBox(height: 10.h),

              // 4. FORMAT CARDS (Strict Base Palette: Obsidian Black & Ungu)
              _buildFormatCard(
                format: ExportFormat.pdf,
                title: "PDF Dokumen Resmi",
                subtitle: "Kop resmi MIErp, tabel terstruktur, siap cetak & tanda tangan",
                icon: Icons.picture_as_pdf_outlined,
                badgeLabel: "RESMI",
              ),
              SizedBox(height: 10.h),
              _buildFormatCard(
                format: ExportFormat.csv,
                title: "Excel Spreadsheet (.csv)",
                subtitle: "Format data tabular untuk Microsoft Excel & Google Sheets",
                icon: Icons.table_chart_outlined,
                badgeLabel: "TABULAR",
              ),
              SizedBox(height: 22.h),

              // 5. ACTION BUTTONS (Batal & Ekspor Berkas)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 46.h,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFF8FAFC),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(
                          "Batal",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.5.sp,
                            fontWeight: AppFontWeight.semiBold,
                            color: const Color(0xFF475569),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 46.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.premiumDarkGradient,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.premiumDarkSolid.withValues(alpha: 0.28),
                              blurRadius: 10.w,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12.r),
                            onTap: _isLoading
                                ? null
                                : () async {
                                    HapticFeedback.mediumImpact();
                                    setState(() => _isLoading = true);
                                    try {
                                      Navigator.of(context).maybePop();
                                      await widget.onExport(_selectedFormat);
                                    } finally {
                                      if (mounted) setState(() => _isLoading = false);
                                    }
                                  },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: Center(
                                child: _isLoading
                                    ? SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.download_rounded,
                                            size: 18.w,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8.w),
                                          Flexible(
                                            child: Text(
                                              "Ekspor Berkas",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 13.5.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
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

  Widget _buildFormatCard({
    required ExportFormat format,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeLabel,
  }) {
    final bool isSelected = _selectedFormat == format;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedFormat = format);
        },
        borderRadius: BorderRadius.circular(14.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.purpleTransparent : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? AppColors.vividPurple : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            children: [
              // Icon Squircle (No rainbow: Obsidian Gradient when selected, Subtle Slate when unselected)
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 42.w,
                height: 42.w,
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.premiumDarkGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(11.r),
                  border: isSelected
                      ? null
                      : Border.all(color: const Color(0xFFE2E8F0), width: 1.w),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.premiumDarkSolid.withValues(alpha: 0.22),
                            blurRadius: 6.r,
                            offset: Offset(0, 2.h),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                    size: 21.w,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: GoogleFonts.inter(
                              fontSize: 13.5.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(5.r),
                            border: isSelected
                                ? Border.all(color: AppColors.lavenderMist, width: 0.8.w)
                                : null,
                          ),
                          child: Text(
                            badgeLabel,
                            style: GoogleFonts.inter(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.vividPurple : const Color(0xFF475569),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: const Color(0xFF64748B),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Selection Radio Circle
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isSelected ? AppColors.premiumDarkGradient : null,
                  color: isSelected ? null : Colors.transparent,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: const Color(0xFFCBD5E1),
                          width: 1.5.w,
                        ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check_rounded,
                        size: 14.w,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
