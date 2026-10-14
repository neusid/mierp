import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import 'package:mierp_apps/core/models/all_summary.dart';
import 'package:mierp_apps/core/models/order.dart';
import 'package:mierp_apps/core/models/product.dart';
import 'package:mierp_apps/core/models/sales_order.dart';
import 'package:mierp_apps/core/models/summary_type.dart';

enum ExportFormat { pdf, csv }

class ExportResult {
  final bool success;
  final String filePath;
  final String fileName;
  final String? errorMessage;

  const ExportResult({
    required this.success,
    required this.filePath,
    required this.fileName,
    this.errorMessage,
  });
}

class ExportService {
  static final _currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0);
  static final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

  // ==========================================
  // 1. EXPORT PRODUCTS (WAREHOUSE INVENTORY)
  // ==========================================
  static Future<ExportResult> exportProducts({
    required List<Product> products,
    required String companyName,
    required ExportFormat format,
    BuildContext? context,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(now);
      final fileName = "Laporan_Stok_Warehouse_${dateStr}.${format == ExportFormat.pdf ? 'pdf' : 'csv'}";

      if (format == ExportFormat.csv) {
        final rows = <List<dynamic>>[
          ["NO", "KODE PRODUK", "NAMA BARANG", "KATEGORI", "STOK", "HARGA SATUAN", "TOTAL VALUASI", "TGL DIBUAT"],
          ...products.asMap().entries.map((entry) {
            final i = entry.key + 1;
            final p = entry.value;
            final totalVal = p.quantity * p.unitPrice;
            return [
              i,
              p.productCode,
              p.productName,
              p.category,
              p.quantity,
              p.unitPrice,
              totalVal,
              p.createdOn,
            ];
          }),
        ];
        final csvData = Csv().encode(rows);
        final file = await _saveFile(fileName, csvData.codeUnits);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      } else {
        final doc = pw.Document();
        final totalQty = products.fold<int>(0, (sum, p) => sum + p.quantity);
        final totalValuation = products.fold<int>(0, (sum, p) => sum + (p.quantity * p.unitPrice));

        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context ctx) => [
              _buildPdfHeader("LAPORAN STOK & VALUASI INVENTARIS", companyName, "Role: Warehouse Management"),
              pw.SizedBox(height: 12),
              _buildMetricsSummaryRow([
                _MetricItem("Total Jenis Produk", "${products.length} SKU"),
                _MetricItem("Total Unit Fisik", "$totalQty Pcs"),
                _MetricItem("Estimasi Nilai Aset", _currencyFormat.format(totalValuation)),
              ]),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2E1052)),
                cellHeight: 24,
                cellStyle: const pw.TextStyle(fontSize: 8.5),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.centerRight,
                  6: pw.Alignment.centerRight,
                },
                headers: ["No", "Kode", "Nama Produk", "Kategori", "Stok", "Harga", "Valuasi"],
                data: products.asMap().entries.map((e) {
                  final p = e.value;
                  return [
                    "${e.key + 1}",
                    p.productCode,
                    p.productName,
                    p.category,
                    "${p.quantity}",
                    _currencyFormat.format(p.unitPrice),
                    _currencyFormat.format(p.quantity * p.unitPrice),
                  ];
                }).toList(),
              ),
            ],
            footer: (pw.Context ctx) => _buildPdfFooter(ctx),
          ),
        );

        final bytes = await doc.save();
        final file = await _saveFile(fileName, bytes);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      }
    } catch (e) {
      return ExportResult(success: false, filePath: '', fileName: '', errorMessage: e.toString());
    }
  }

  // ==========================================
  // 2. EXPORT WAREHOUSE ORDERS (RESTOCK/PURCHASE)
  // ==========================================
  static Future<ExportResult> exportWarehouseOrders({
    required List<OrderProduct> orders,
    required String companyName,
    required ExportFormat format,
    BuildContext? context,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(now);
      final fileName = "Laporan_Warehouse_Orders_${dateStr}.${format == ExportFormat.pdf ? 'pdf' : 'csv'}";

      if (format == ExportFormat.csv) {
        final rows = <List<dynamic>>[
          ["NO", "ID INVOICE", "NAMA BARANG", "PEMESAN", "JUMLAH", "TOTAL BIAYA", "STATUS PERSETUJUAN", "TGL PESAN"],
          ...orders.asMap().entries.map((entry) {
            final i = entry.key + 1;
            final o = entry.value;
            String status = "PENDING";
            if (o.isRejected == true) status = "DITOLAK (REJECTED)";
            if (o.financeApproved == true) status = "DISETUJUI (PAID)";
            return [
              i,
              o.id ?? '-',
              o.productName,
              o.firstName,
              o.quantity,
              o.totalCost,
              status,
              o.orderDate ?? '-',
            ];
          }),
        ];
        final csvData = Csv().encode(rows);
        final file = await _saveFile(fileName, csvData.codeUnits);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      } else {
        final doc = pw.Document();
        final totalCost = orders.fold<int>(0, (sum, o) => sum + o.totalCost);
        final approvedCount = orders.where((o) => o.financeApproved == true).length;
        final pendingCount = orders.where((o) => o.financeApproved != true && o.isRejected != true).length;

        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context ctx) => [
              _buildPdfHeader("LAPORAN PESANAN PENGADAAN BARANG (ORDERS)", companyName, "Warehouse & Procurement"),
              pw.SizedBox(height: 12),
              _buildMetricsSummaryRow([
                _MetricItem("Total Pesanan", "${orders.length} Transaksi"),
                _MetricItem("Status Persetujuan", "$approvedCount Lunas / $pendingCount Menunggu"),
                _MetricItem("Total Anggaran", _currencyFormat.format(totalCost)),
              ]),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2E1052)),
                cellHeight: 24,
                cellStyle: const pw.TextStyle(fontSize: 8.5),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.center,
                },
                headers: ["No", "Barang", "Pemohon", "Qty", "Total Biaya", "Status"],
                data: orders.asMap().entries.map((e) {
                  final o = e.value;
                  String statusText = "Menunggu";
                  if (o.isRejected == true) statusText = "Ditolak";
                  if (o.financeApproved == true) statusText = "Disetujui";
                  return [
                    "${e.key + 1}",
                    o.productName,
                    o.firstName,
                    "${o.quantity}",
                    _currencyFormat.format(o.totalCost),
                    statusText,
                  ];
                }).toList(),
              ),
            ],
            footer: (pw.Context ctx) => _buildPdfFooter(ctx),
          ),
        );

        final bytes = await doc.save();
        final file = await _saveFile(fileName, bytes);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      }
    } catch (e) {
      return ExportResult(success: false, filePath: '', fileName: '', errorMessage: e.toString());
    }
  }

  // ==========================================
  // 3. EXPORT SALES ORDERS (FINANCE & REVENUE)
  // ==========================================
  static Future<ExportResult> exportSalesOrders({
    required List<SalesOrder> salesOrders,
    required String companyName,
    required ExportFormat format,
    BuildContext? context,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(now);
      final fileName = "Laporan_Sales_Orders_${dateStr}.${format == ExportFormat.pdf ? 'pdf' : 'csv'}";

      if (format == ExportFormat.csv) {
        final rows = <List<dynamic>>[
          ["NO", "ID INVOICE", "NAMA BARANG", "PERUSAHAAN/KLIEN", "QTY", "TOTAL HARGA", "STATUS BAYAR", "TGL BELI"],
          ...salesOrders.asMap().entries.map((entry) {
            final i = entry.key + 1;
            final s = entry.value;
            String status = "PENDING";
            if (s.isRejected == true) status = "DITOLAK";
            if (s.financeApproved == true || s.paymentStatus == true) status = "LUNAS (PAID)";
            return [
              i,
              s.id ?? '-',
              s.productName,
              s.companyName,
              s.quantity,
              s.totalPrice,
              status,
              s.purchasedDate,
            ];
          }),
        ];
        final csvData = Csv().encode(rows);
        final file = await _saveFile(fileName, csvData.codeUnits);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      } else {
        final doc = pw.Document();
        final totalRevenue = salesOrders.fold<int>(0, (sum, s) => sum + s.totalPrice);
        final paidRevenue = salesOrders
            .where((s) => s.financeApproved == true || s.paymentStatus == true)
            .fold<int>(0, (sum, s) => sum + s.totalPrice);

        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context ctx) => [
              _buildPdfHeader("LAPORAN PENJUALAN & PENDAPATAN (SALES ORDERS)", companyName, "Role: Finance & Revenue"),
              pw.SizedBox(height: 12),
              _buildMetricsSummaryRow([
                _MetricItem("Total Transaksi", "${salesOrders.length} Pesanan"),
                _MetricItem("Pendapatan Terealisasi", _currencyFormat.format(paidRevenue)),
                _MetricItem("Nilai Keseluruhan", _currencyFormat.format(totalRevenue)),
              ]),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2E1052)),
                cellHeight: 24,
                cellStyle: const pw.TextStyle(fontSize: 8.5),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.centerLeft,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                  5: pw.Alignment.center,
                },
                headers: ["No", "Barang", "Pelanggan/Klien", "Qty", "Total Penjualan", "Status"],
                data: salesOrders.asMap().entries.map((e) {
                  final s = e.value;
                  String status = "Menunggu";
                  if (s.isRejected == true) status = "Ditolak";
                  if (s.financeApproved == true || s.paymentStatus == true) status = "Lunas";
                  return [
                    "${e.key + 1}",
                    s.productName,
                    s.companyName,
                    "${s.quantity}",
                    _currencyFormat.format(s.totalPrice),
                    status,
                  ];
                }).toList(),
              ),
            ],
            footer: (pw.Context ctx) => _buildPdfFooter(ctx),
          ),
        );

        final bytes = await doc.save();
        final file = await _saveFile(fileName, bytes);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      }
    } catch (e) {
      return ExportResult(success: false, filePath: '', fileName: '', errorMessage: e.toString());
    }
  }

  // ==========================================
  // 4. EXPORT ALL SUMMARY COMBINED
  // ==========================================
  static Future<ExportResult> exportAllSummary({
    required List<AllSummary> summaries,
    required String companyName,
    required ExportFormat format,
    BuildContext? context,
  }) async {
    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(now);
      final fileName = "Laporan_Rekapitulasi_MiERP_${dateStr}.${format == ExportFormat.pdf ? 'pdf' : 'csv'}";

      if (format == ExportFormat.csv) {
        final rows = <List<dynamic>>[
          ["NO", "ID TRANSAKSI", "NAMA BARANG", "KATEGORI", "STATUS", "TOTAL NILAI"],
          ...summaries.asMap().entries.map((entry) {
            final i = entry.key + 1;
            final s = entry.value;
            return [
              i,
              _getAllSummaryId(s),
              _getAllSummaryName(s),
              _getAllSummaryCategory(s),
              _getAllSummaryStatus(s),
              _getAllSummaryPrice(s),
            ];
          }),
        ];
        final csvData = Csv().encode(rows);
        final file = await _saveFile(fileName, csvData.codeUnits);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      } else {
        final doc = pw.Document();
        final totalSum = summaries.fold<int>(0, (sum, s) => sum + _getAllSummaryPrice(s));

        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context ctx) => [
              _buildPdfHeader("LAPORAN REKAPITULASI AKTIVITAS OPERASIONAL", companyName, "MiERP Consolidated Summary"),
              pw.SizedBox(height: 12),
              _buildMetricsSummaryRow([
                _MetricItem("Total Rekap Data", "${summaries.length} Item"),
                _MetricItem("Status", "Multi-Modul"),
                _MetricItem("Total Akumulasi", _currencyFormat.format(totalSum)),
              ]),
              pw.SizedBox(height: 16),
              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
                headerDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFF2E1052)),
                cellHeight: 24,
                cellStyle: const pw.TextStyle(fontSize: 8.5),
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.centerRight,
                },
                headers: ["No", "Nama Barang", "Kategori Transaksi", "Status", "Total"],
                data: summaries.asMap().entries.map((e) {
                  final s = e.value;
                  return [
                    "${e.key + 1}",
                    _getAllSummaryName(s),
                    _getAllSummaryCategory(s),
                    _getAllSummaryStatus(s),
                    _currencyFormat.format(_getAllSummaryPrice(s)),
                  ];
                }).toList(),
              ),
            ],
            footer: (pw.Context ctx) => _buildPdfFooter(ctx),
          ),
        );

        final bytes = await doc.save();
        final file = await _saveFile(fileName, bytes);
        if (context != null && context.mounted) {
          _showPostExportFeedback(context, file.path, fileName);
        }
        return ExportResult(success: true, filePath: file.path, fileName: fileName);
      }
    } catch (e) {
      return ExportResult(success: false, filePath: '', fileName: '', errorMessage: e.toString());
    }
  }

  // ==========================================
  // HELPER: ALL SUMMARY DATA EXTRACTORS
  // ==========================================
  static String _getAllSummaryId(AllSummary s) {
    if (s.data is Product) return (s.data as Product).productCode;
    if (s.data is OrderProduct) return (s.data as OrderProduct).id ?? '-';
    if (s.data is SalesOrder) return (s.data as SalesOrder).id ?? '-';
    return '-';
  }

  static String _getAllSummaryName(AllSummary s) {
    if (s.data is Product) return (s.data as Product).productName;
    if (s.data is OrderProduct) return (s.data as OrderProduct).productName;
    if (s.data is SalesOrder) return (s.data as SalesOrder).productName;
    return s.data?.productName?.toString() ?? '-';
  }

  static String _getAllSummaryCategory(AllSummary s) {
    switch (s.summaryType) {
      case SummaryType.product:
        return "Product Stock";
      case SummaryType.order:
        return "Warehouse Order";
      case SummaryType.salesOrder:
        return "Sales Order";
    }
  }

  static String _getAllSummaryStatus(AllSummary s) {
    if (s.data is Product) return "Tersedia";
    if (s.data is OrderProduct) {
      final o = s.data as OrderProduct;
      if (o.isRejected == true) return "Ditolak";
      if (o.financeApproved == true) return "Disetujui (Paid)";
      return "Menunggu";
    }
    if (s.data is SalesOrder) {
      final so = s.data as SalesOrder;
      if (so.isRejected == true) return "Ditolak";
      if (so.financeApproved == true || so.paymentStatus == true) return "Lunas (Paid)";
      return "Menunggu";
    }
    return "-";
  }

  static int _getAllSummaryPrice(AllSummary s) {
    if (s.data is Product) {
      final p = s.data as Product;
      return p.quantity * p.unitPrice;
    }
    if (s.data is OrderProduct) return (s.data as OrderProduct).totalCost;
    if (s.data is SalesOrder) return (s.data as SalesOrder).totalPrice;
    return 0;
  }

  // ==========================================
  // HELPER: PDF HEADER, METRICS, & FOOTER
  // ==========================================
  static pw.Widget _buildPdfHeader(String title, String companyName, String subtitle) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "MiERP",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                    color: const PdfColor.fromInt(0xFF2E1052),
                  ),
                ),
                pw.Text(
                  companyName.isNotEmpty ? companyName : "PT MiERP Indonesia",
                  style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  subtitle,
                  style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  "DOKUMEN RESMI",
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF7C3AED)),
                ),
                pw.Text(
                  "Tanggal: ${_dateFormat.format(DateTime.now())}",
                  style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700),
                ),
                pw.Text(
                  "Status: Confidential (ERP Internal)",
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(color: const PdfColor.fromInt(0xFF7C3AED), thickness: 1.5),
        pw.SizedBox(height: 4),
        pw.Center(
          child: pw.Text(
            title,
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF1E293B)),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildMetricsSummaryRow(List<_MetricItem> items) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: const PdfColor.fromInt(0xFFF8FAFC),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: items.map((item) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(item.label, style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              pw.SizedBox(height: 2),
              pw.Text(
                item.value,
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xFF0F172A)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  static pw.Widget _buildPdfFooter(pw.Context ctx) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Dicetak otomatis via MiERP Mobile Platform", style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey500)),
          pw.Text("Halaman ${ctx.pageNumber} dari ${ctx.pagesCount}", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
        ],
      ),
    );
  }

  // ==========================================
  // HELPER: FILE SAVING & POST-EXPORT UI
  // ==========================================
  static Future<File> _saveFile(String fileName, List<int> bytes) async {
    Directory outputDir;
    try {
      outputDir = (await getDownloadsDirectory()) ?? (await getApplicationDocumentsDirectory());
    } catch (_) {
      outputDir = await getApplicationDocumentsDirectory();
    }
    final file = File("${outputDir.path}/$fileName");
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static void _showPostExportFeedback(BuildContext context, String filePath, String fileName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
              ),
              child: const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 30),
            ),
            const SizedBox(height: 14),
            const Text(
              "Laporan Berhasil Dibuat",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            Text(
              fileName,
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.visibility_outlined, size: 18, color: Color(0xFF334155)),
                    label: const Text("Buka Berkas", style: TextStyle(color: Color(0xFF334155), fontWeight: FontWeight.w600)),
                    onPressed: () async {
                      Navigator.pop(ctx);
                      try {
                        final result = await OpenFilex.open(filePath);
                        if (result.type != ResultType.done && context.mounted) {
                          Share.shareXFiles([XFile(filePath)], text: "Laporan $fileName dari MiERP Mobile");
                        }
                      } catch (e) {
                        debugPrint("OpenFilex fallback to Share due to: $e");
                        if (context.mounted) {
                          Share.shareXFiles([XFile(filePath)], text: "Laporan $fileName dari MiERP Mobile");
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E1052),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.share_rounded, size: 18, color: Colors.white),
                    label: const Text("Bagikan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Share.shareXFiles([XFile(filePath)], text: "Laporan $fileName dari MiERP Mobile");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;
  const _MetricItem(this.label, this.value);
}
