// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:myapp/main.dart';

void main() {
  testWidgets('Scan for Devices adds a new device to the list',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that there are no devices in the list initially.
    expect(find.byType(DeviceCard), findsNothing);

    // Find the "Scan for Devices" button.
    final scanButton = find.text('Scan for Devices');

    // Verify that the button exists.
    expect(scanButton, findsOneWidget);

    // Tap the "Scan for Devices" button and trigger a frame.
    await tester.tap(scanButton);
    await tester.pump();

    // Verify that a new device card is now visible.
    expect(find.byType(DeviceCard), findsWidgets);
  });
}
