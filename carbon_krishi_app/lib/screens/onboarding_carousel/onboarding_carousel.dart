import 'package:cached_network_image/cached_network_image.dart';
import 'package:carbon_krishi_app/widgets/custom_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart'; // ✅ CHANGE: added

/// Onboarding Carousel Screen
/// Introduces farmers to carbon credit earning through sustainable practices
/// Features three educational slides with Hindi/English language toggle
class OnboardingCarousel extends StatefulWidget {
  const OnboardingCarousel({super.key});

  @override
  State<OnboardingCarousel> createState() => _OnboardingCarouselState();
}

class _OnboardingCarouselState extends State<OnboardingCarousel> {
  final GlobalKey<IntroductionScreenState> _introKey =
      GlobalKey<IntroductionScreenState>();

  bool _isHindi = true;

  // ✅ CHANGE 1: farmer name variable
  late String farmerName;

  // ✅ CHANGE 2: read farmer name from route arguments
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    farmerName =
        ModalRoute.of(context)?.settings.arguments as String? ?? 'Farmer';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            IntroductionScreen(
              key: _introKey,
              pages: _buildPages(theme),
              showSkipButton: true,
              showNextButton: true,
              showDoneButton: true,
              skip: Text(
                _isHindi ? 'छोड़ें' : 'Skip',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              next: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isHindi ? 'आगे' : 'Next',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              done: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isHindi ? 'शुरू करें' : 'Get Started',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),

              // ✅ CHANGE 3: fixed navigation
              onDone: _navigateToHome,
              onSkip: _navigateToHome,

              dotsDecorator: DotsDecorator(
                size: const Size.square(10),
                activeSize: const Size(24, 10),
                activeColor: theme.colorScheme.primary,
                color: theme.colorScheme.onSurface.withAlpha(
                  (0.3 * 255).toInt(),
                ),
                spacing: const EdgeInsets.symmetric(horizontal: 4),
                activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              globalBackgroundColor: theme.scaffoldBackgroundColor,
              skipOrBackFlex: 0,
              nextFlex: 0,
              curve: Curves.easeInOut,
              controlsMargin: const EdgeInsets.all(16),
              controlsPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 16,
              ),
              dotsContainerDecorator: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _buildLanguageToggle(theme),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== UNCHANGED CODE BELOW =====================

  List<PageViewModel> _buildPages(ThemeData theme) {
    return [
      PageViewModel(
        title: _isHindi ? 'कार्बन प्रभाव को समझें' : 'Understand Carbon Impact',
        body: _isHindi
            ? 'अपनी खेती के तरीकों से पर्यावरण पर पड़ने वाले प्रभाव को जानें और कार्बन उत्सर्जन को कम करने के तरीके सीखें'
            : 'Learn how your farming practices impact the environment and discover ways to reduce carbon emissions',
        image: _buildPageImage(
          'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=800&q=80',
          'Aerial view of green agricultural fields with crop rows showing sustainable farming practices',
          theme,
        ),
        decoration: _getPageDecoration(theme),
      ),
      PageViewModel(
        title: _isHindi ? 'कार्बन क्रेडिट कमाएं' : 'Earn Carbon Credits',
        body: _isHindi
            ? 'टिकाऊ खेती के तरीकों को अपनाकर कार्बन क्रेडिट अर्जित करें और अतिरिक्त आय प्राप्त करें'
            : 'Adopt sustainable farming practices to earn carbon credits and generate additional income',
        image: _buildPageImage(
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800&q=80',
          'Indian farmer holding green plants in fertile soil with coins overlay representing carbon credits',
          theme,
        ),
        decoration: _getPageDecoration(theme),
      ),
      PageViewModel(
        title: _isHindi ? 'अपनी प्रगति ट्रैक करें' : 'Track Your Progress',
        body: _isHindi
            ? 'अपने कार्बन स्कोर, कमाई और पर्यावरणीय योगदान को आसान डैशबोर्ड पर देखें और AI सुझाव प्राप्त करें'
            : 'Monitor your carbon score, earnings, and environmental contributions on an easy dashboard with AI recommendations',
        image: _buildPageImage(
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?w=800&q=80',
          'Digital dashboard showing charts and graphs with green growth indicators and sustainability metrics',
          theme,
        ),
        decoration: _getPageDecoration(theme),
      ),
    ];
  }

  Widget _buildPageImage(
    String imageUrl,
    String semanticLabel,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.broken_image, size: 48),
          ),
        ),
      ),
    );
  }

  PageDecoration _getPageDecoration(ThemeData theme) {
    return PageDecoration(
      titleTextStyle:
          theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ) ??
          const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      bodyTextStyle:
          theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).toInt()),
            height: 1.5,
          ) ??
          const TextStyle(fontSize: 16),
      titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      bodyPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      imagePadding: const EdgeInsets.only(top: 24),
      contentMargin: const EdgeInsets.symmetric(horizontal: 16),
      pageColor: Colors.transparent,
    );
  }

  Widget _buildLanguageToggle(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha((0.1 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isHindi = !_isHindi;
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'language',
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  _isHindi ? 'EN' : 'हिं',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ CHANGE 3: navigation fixed
  void _navigateToHome() {
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.homeDashboard,
      arguments: farmerName,
    );
  }
}