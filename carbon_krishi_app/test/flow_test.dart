import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carbon_krishi_app/main.dart';
import 'package:carbon_krishi_app/screens/splash_screen.dart';
import 'package:carbon_krishi_app/screens/registration_screen.dart';
import 'package:carbon_krishi_app/screens/onboarding_carousel/onboarding_carousel.dart';

void main() {
  testWidgets('Full app navigation flow test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CarbonKrishiApp());

    // 1. App starts on the SplashScreen
    expect(find.byType(SplashScreen), findsOneWidget);

    // Wait for the splash screen to finish and navigate to the RegistrationScreen
    await tester.pumpAndSettle(const Duration(seconds: 7));

    // 2. App navigates to the RegistrationScreen
    expect(find.byType(RegistrationScreen), findsOneWidget);

    // 3. Fill out the registration form
    await tester.enterText(find.byType(TextFormField).at(0), '1234567890');
    await tester.enterText(find.byType(TextFormField).at(1), 'Test Farmer');
    await tester.tap(find.byType(DropdownButtonFormField));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pimpri').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), '10');

    // 4. Tap the "Register with OTP" button
    await tester.tap(find.text('Register with OTP'));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 5. App navigates to the OnboardingCarousel
    expect(find.byType(OnboardingCarousel), findsOneWidget);
  });
}
