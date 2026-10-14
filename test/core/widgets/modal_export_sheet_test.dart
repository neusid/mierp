import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mierp_apps/core/services/export_service.dart';
import 'package:mierp_apps/core/widgets/modal_export_sheet.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, _) => MaterialApp(
        home: Scaffold(body: child),
      ),
    );
  }

  group('ModalExportSheet Widget Tests', () {
    testWidgets('renders modal with base palette and triggers onExport when tapped', (tester) async {
      tester.view.physicalSize = const Size(375 * 2, 812 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      ExportFormat? selectedFormat;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                ModalExportSheet.show(
                  ctx,
                  reportTitle: "Laporan Stok & Valuasi",
                  subtitle: "Unduh atau bagikan inventaris & nilai aset gudang",
                  onExport: (format) async {
                    selectedFormat = format;
                  },
                );
              },
              child: const Text("Open Export Modal"),
            ),
          ),
        ),
      );

      // Open Modal
      await tester.tap(find.text("Open Export Modal"));
      await tester.pumpAndSettle();

      // Verify Header & Anti-AI-slop Elements
      expect(find.text("Laporan Stok & Valuasi"), findsOneWidget);
      expect(find.text("Unduh atau bagikan inventaris & nilai aset gudang"), findsOneWidget);
      expect(find.text("PILIH FORMAT DOKUMEN"), findsOneWidget);
      expect(find.text("PDF Dokumen Resmi"), findsOneWidget);
      expect(find.text("Excel Spreadsheet (.csv)"), findsOneWidget);
      expect(find.text("Batal"), findsOneWidget);
      expect(find.text("Ekspor Berkas"), findsOneWidget);

      // Select CSV format card
      await tester.tap(find.text("Excel Spreadsheet (.csv)"));
      await tester.pumpAndSettle();

      // Tap "Ekspor Berkas"
      await tester.tap(find.text("Ekspor Berkas"));
      await tester.pumpAndSettle();

      expect(selectedFormat, equals(ExportFormat.csv));
    });

    testWidgets('cancels export when Batal button is tapped', (tester) async {
      tester.view.physicalSize = const Size(375 * 2, 812 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool exportInvoked = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                ModalExportSheet.show(
                  ctx,
                  reportTitle: "Laporan Keuangan",
                  onExport: (format) async {
                    exportInvoked = true;
                  },
                );
              },
              child: const Text("Open Export Modal"),
            ),
          ),
        ),
      );

      await tester.tap(find.text("Open Export Modal"));
      await tester.pumpAndSettle();

      expect(find.text("Laporan Keuangan"), findsOneWidget);

      // Tap "Batal"
      await tester.tap(find.text("Batal"));
      await tester.pumpAndSettle();

      expect(exportInvoked, isFalse);
      expect(find.text("Laporan Keuangan"), findsNothing);
    });
  });
}
