import 'package:flutter/material.dart';

import '../screens/farm_data_entry_screen.dart';
import '../screens/carbon_score_display/carbon_score_display.dart';
import '../screens/home_dashboard_screen.dart'; // ✅ fixed slash
import '../screens/photo_upload_screen.dart';
import '../screens/onboarding_carousel/onboarding_carousel.dart';
import '../screens/registration_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/carbon_credits_ledger/carbon_credits_ledger.dart';

class AppRoutes {
  static const String initial = '/';
  static const String registration = '/registration';
  static const String carbonCreditsLedger = '/carbon-credits-ledger';
  static const String farmDataEntry = '/farm-data-entry';
  static const String carbonScoreDisplay = '/carbon-score-display';
  static const String homeDashboard = '/home-dashboard';
  static const String photoUpload = '/photo-upload';
  static const String onboardingCarousel = '/onboarding-carousel';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    registration: (context) => const RegistrationScreen(),
    carbonCreditsLedger: (context) => const CarbonCreditsLedger(),
    farmDataEntry: (context) => const FarmDataEntryScreen(),
    carbonScoreDisplay: (context) => const CarbonScoreDisplay(),

    // ✅ MOST IMPORTANT FIX
    homeDashboard: (context) {
      final farmerName = ModalRoute.of(context)?.settings.arguments as String?;

      return HomeDashboardScreen(farmerName: farmerName ?? 'Farmer');
    },

    photoUpload: (context) => const PhotoUploadScreen(),
    onboardingCarousel: (context) => const OnboardingCarousel(),
  };
}
