import 'package:flutter/material.dart';
import 'registration_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      icon: Icons.co2,
      title: 'Measure Your Carbon Impact',
      description: 'Track how your farming helps the planet',
      color: const Color(0xFF2E7D32),
    ),
    OnboardingContent(
      icon: Icons.monetization_on,
      title: 'Earn Carbon Credits',
      description: 'Get rewards for sustainable farming',
      color: const Color(0xFF66BB6A),
    ),
    OnboardingContent(
      icon: Icons.dashboard,
      title: 'Simple Dashboard',
      description: 'See your progress in real-time',
      color: const Color(0xFF8BC34A),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => _navigateToRegistration(),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildIndicator(index == _currentPage),
              ),
            ),
            const SizedBox(height: 24),

            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _navigateToRegistration();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: content.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              content.icon,
              size: 100,
              color: content.color,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF757575),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2E7D32) : const Color(0xFFBDBDBD),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  void _navigateToRegistration() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegistrationScreen()),
    );
  }
}

class OnboardingContent {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}