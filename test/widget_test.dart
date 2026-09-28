import 'package:demo_calculator/app/app.dart';
import 'package:demo_calculator/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();
  });

  testWidgets('Calculator smoke test - performs 7 + 8 = 15', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify initial state is 0
    expect(find.byKey(const Key('calculator_display_text')), findsOneWidget);
    expect(find.text('0'), findsWidgets);

    // Tap button 7
    await tester.tap(find.byKey(const Key('btn_7')));
    await tester.pumpAndSettle();

    // Tap button +
    await tester.tap(find.byKey(const Key('btn_+')));
    await tester.pumpAndSettle();

    // Tap button 8
    await tester.tap(find.byKey(const Key('btn_8')));
    await tester.pumpAndSettle();

    // Tap button =
    await tester.tap(find.byKey(const Key('btn_=')));
    await tester.pumpAndSettle();

    // Verify result is 15
    expect(find.text('15'), findsOneWidget);

    // Tap AC
    await tester.tap(find.byKey(const Key('btn_AC')));
    await tester.pumpAndSettle();

    // Verify reset to 0
    expect(find.text('0'), findsWidgets);
  });
}
