// This is a basic Flutter widget test.
// For more information about testing with Flutter, please refer to:
// https://flutter.dev/docs/testing

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:carbon_krishi_app/services/location_service.dart';
import 'package:carbon_krishi_app/main.dart';

void main() {
  testWidgets('CarbonKrishiApp loads without crashing', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CarbonKrishiApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the app title is displayed.
    expect(find.text('CarbonKrishi by NexAi'), findsOneWidget);
  });
}
