import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mierp_apps/core/services/export_service.dart';
import 'package:mierp_apps/core/theme/app_colors.dart';

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
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Header
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.ios_share_rounded, color: const Color(0xFF7C3AED), size: 22.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reportTitle,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: const Color(0xFF64748B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Format options
          Text(
            "Pilih Format Dokumen",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          SizedBox(height: 10.h),

          // PDF Option
          _buildFormatCard(
            format: ExportFormat.pdf,
            title: "PDF Dokumen Resmi",
            subtitle: "Kop resmi MiERP, tabel terstruktur, siap cetak & tanda tangan",
            icon: Icons.picture_as_pdf_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBg: const Color(0xFFFEF2F2),
          ),
          SizedBox(height: 10.h),

          // CSV / Excel Option
          _buildFormatCard(
            format: ExportFormat.csv,
            title: "Excel Spreadsheet (.csv)",
            subtitle: "Tabel data tabular kompatibel Microsoft Excel & Google Sheets",
            icon: Icons.table_chart_rounded,
            iconColor: const Color(0xFF10B981),
            iconBg: const Color(0xFFF0FDF4),
          ),
          SizedBox(height: 24.h),

          // Action button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.premiumDarkGradient,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2E1052).withValues(alpha: 0.25),
                    blurRadius: 8.w,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isLoading
                      ? null
                      : () async {
                          setState(() => _isLoading = true);
                          try {
                            Navigator.pop(context);
                            await widget.onExport(_selectedFormat);
                          } finally {
                            if (mounted) setState(() => _isLoading = false);
                          }
                        },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Center(
                    child: _isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.download_rounded, color: Colors.white, size: 20.w),
                              SizedBox(width: 8.w),
                              Text(
                                "Ekspor & Bagikan Laporan",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatCard({
    required ExportFormat format,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    final isSelected = _selectedFormat == format;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedFormat = format),
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFAF5FF) : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFE2E8F0),
              width: isSelected ? 1.5.w : 1.w,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 22.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFFCBD5E1),
                    width: 2.w,
                  ),
                  color: isSelected ? const Color(0xFF7C3AED) : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 13.w, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
