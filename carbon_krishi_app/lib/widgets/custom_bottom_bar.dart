import 'package:flutter/material.dart';

/// Navigation item configuration for bottom navigation bar
class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;

  const BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
  });
}

/// Custom bottom navigation bar widget optimized for agricultural app
/// Implements thumb-friendly navigation with increased touch targets (minimum 48dp)
/// Provides clear visual feedback for outdoor usability
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Primary navigation items mapped to app routes
  /// Based on Mobile Navigation Hierarchy from design specifications
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      route: '/home-dashboard',
    ),
    BottomNavItem(
      label: 'Farm Data',
      icon: Icons.agriculture_outlined,
      activeIcon: Icons.agriculture,
      route: '/farm-data-entry',
    ),
    BottomNavItem(
      label: 'Photos',
      icon: Icons.photo_camera_outlined,
      activeIcon: Icons.photo_camera,
      route: '/photo-upload',
    ),
    BottomNavItem(
      label: 'Credits',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      route: '/carbon-credits-ledger',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64, // Increased height for better thumb reach
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              _navItems.length,
              (index) => _buildNavItem(
                context: context,
                item: _navItems[index],
                index: index,
                isSelected: currentIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required BottomNavItem item,
    required int index,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;

    final color = isSelected
        ? (bottomNavTheme.selectedItemColor ?? colorScheme.primary)
        : (bottomNavTheme.unselectedItemColor ??
              colorScheme.onSurface.withValues(alpha: 0.6));

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap(index);
            // Navigate to the corresponding route
            if (!isSelected) {
              Navigator.pushNamed(context, item.route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: colorScheme.primary.withValues(alpha: 0.1),
          highlightColor: colorScheme.primary.withValues(alpha: 0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon with animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                // Label with animation
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  style:
                      (isSelected
                          ? bottomNavTheme.selectedLabelStyle
                          : bottomNavTheme.unselectedLabelStyle) ??
                      TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: color,
                      ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension to easily add CustomBottomBar to Scaffold
extension CustomBottomBarExtension on Widget {
  Widget withCustomBottomBar({
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return Builder(
      builder: (context) {
        return Scaffold(
          body: this,
          bottomNavigationBar: CustomBottomBar(
            currentIndex: currentIndex,
            onTap: onTap,
          ),
        );
      },
    );
  }
}
