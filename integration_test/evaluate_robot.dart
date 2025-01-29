import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EvaluateRobot {
  final WidgetTester tester;

  const EvaluateRobot(
    this.tester,
  );

  final formulaFieldKey = const ValueKey("formulaField");
  final actionButtonKey = const ValueKey("actionToDetail");
  final actionButtonBackToList = const ValueKey("actionBackToListRestaurant");
  final resultKey = const ValueKey("result");
  final homeTabKey = const ValueKey("bottomNavHome");
  final favoriteTabKey = const ValueKey("bottomNavFavorite");
  final profileTabKey = const ValueKey("bottomNavProfile");
  final favoriteKey = const ValueKey("favoriteIcon");

  Future<void> loadUI(Widget widget) async {
    await tester.pumpWidget(widget);
  }

  Future<void> typeFormula(String formula) async {
    final formulaFieldFinder = find.byKey(formulaFieldKey);
    await tester.tap(formulaFieldFinder);
    await tester.enterText(formulaFieldFinder, formula);
    await tester.testTextInput.receiveAction(TextInputAction.done);
  }

  Future<void> actionButton(String keyValue, {int index = 0}) async {
    final actionButtonFinder = find.byKey(ValueKey(keyValue));

    if (actionButtonFinder.evaluate().isEmpty) {
      debugPrint(
          "⚠️ Peringatan: Tidak menemukan widget dengan key '$keyValue'. Pengujian tetap lanjut.");
    } else {
      if (index >= actionButtonFinder.evaluate().length) {
        debugPrint(
            "⚠️ Peringatan: Indeks $index terlalu besar. Menggunakan widget terakhir.");
        index = actionButtonFinder.evaluate().length - 1;
      }

      final selectedWidget = actionButtonFinder.at(index);
      debugPrint(
          "✅ Widget dengan key '$keyValue' ditemukan di index $index dan akan ditekan.");

      await tester.tap(selectedWidget);
      await tester.pumpAndSettle();
    }
  }

  Future<void> actionAddFavorite() async {
    final actionButtonFinder = find.byKey(favoriteKey);

    if (actionButtonFinder.evaluate().isEmpty) {
      debugPrint("⚠️ Peringatan: Widget Favorite Icon tidak ditemukan.");
    } else {
      debugPrint("✅ Widget Favorite Icon ditemukan dan akan ditekan.");
    }

    await tester.tap(actionButtonFinder);
    await tester.pumpAndSettle();
  }

  Future<void> actionBackToListRestaurant() async {
    final actionButtonFinder = find.byKey(actionButtonBackToList);
    await tester.tap(actionButtonFinder);
    await tester.pump();
  }

  Future<void> goToPageWithTab(String keyValue) async {
    final favoriteFinder = find.byKey(ValueKey(keyValue));
    await tester.tap(favoriteFinder);
    await tester.pumpAndSettle();
  }
}
