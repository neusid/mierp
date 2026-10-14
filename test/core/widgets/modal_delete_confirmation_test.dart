import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mierp_apps/core/widgets/modal_delete_confirmation.dart';

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

  group('ModalDeleteConfirmation Widget Tests', () {
    testWidgets('renders modal and triggers onConfirm when confirm button tapped', (tester) async {
      tester.view.physicalSize = const Size(375 * 2, 812 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool confirmed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                ModalDeleteConfirmation.show(
                  context: ctx,
                  title: "Hapus Akun Anda?",
                  message: "Data Anda akan dihapus secara permanen.",
                  confirmText: "Hapus Akun",
                  cancelText: "Batal",
                  accountName: "John Doe",
                  accountEmail: "john@mierp.com",
                  roleBadge: "admin",
                  onConfirm: () => confirmed = true,
                );
              },
              child: const Text("Open Modal"),
            ),
          ),
        ),
      );

      // Tap button to open modal bottom sheet
      await tester.tap(find.text("Open Modal"));
      await tester.pumpAndSettle();

      expect(find.text("Hapus Akun Anda?"), findsOneWidget);
      expect(find.text("Data Anda akan dihapus secara permanen."), findsOneWidget);
      expect(find.text("John Doe"), findsOneWidget);
      expect(find.text("john@mierp.com"), findsOneWidget);
      expect(find.text("ADMIN"), findsOneWidget);
      expect(find.text("Hapus Akun"), findsOneWidget);
      expect(find.text("Batal"), findsOneWidget);

      // Tap confirm button
      await tester.tap(find.text("Hapus Akun"));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
    });

    testWidgets('cancels without invoking onConfirm when Batal tapped', (tester) async {
      tester.view.physicalSize = const Size(375 * 2, 812 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool confirmed = false;

      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () {
                ModalDeleteConfirmation.show(
                  context: ctx,
                  title: "Hapus Staf?",
                  message: "Akses staf akan dicabut.",
                  confirmText: "Hapus Staf",
                  onConfirm: () => confirmed = true,
                );
              },
              child: const Text("Open Modal"),
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.text("Open Modal"));
      await tester.pumpAndSettle();

      expect(find.text("Hapus Staf?"), findsOneWidget);
      expect(find.text("Batal"), findsOneWidget);

      // Tap cancel button
      await tester.tap(find.text("Batal"));
      await tester.pumpAndSettle();

      expect(confirmed, isFalse);
    });
  });
}
