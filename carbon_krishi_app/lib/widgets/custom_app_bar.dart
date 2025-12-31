import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// App bar variant types for different screen contexts
enum AppBarVariant {
  /// Standard app bar with title and optional actions
  standard,

  /// App bar with back button for navigation
  withBack,

  /// App bar with search functionality
  withSearch,

  /// Transparent app bar for overlays (e.g., camera screen)
  transparent,

  /// App bar with profile/settings actions
  withProfile,
}

/// Custom app bar widget optimized for agricultural carbon tracking app
/// Implements clean, minimal design with high contrast for outdoor visibility
/// Supports multiple variants for different screen contexts
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final AppBarVariant variant;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onProfilePressed;
  final bool centerTitle;
  final Widget? leading;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = AppBarVariant.standard,
    this.actions,
    this.onBackPressed,
    this.onSearchPressed,
    this.onProfilePressed,
    this.centerTitle = false,
    this.leading,
    this.elevation = 2.0,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
  });

  /// Factory constructor for standard app bar
  factory CustomAppBar.standard({
    required String title,
    List<Widget>? actions,
    bool centerTitle = false,
    PreferredSizeWidget? bottom,
  }) {
    return CustomAppBar(
      title: title,
      variant: AppBarVariant.standard,
      actions: actions,
      centerTitle: centerTitle,
      bottom: bottom,
    );
  }

  /// Factory constructor for app bar with back button
  factory CustomAppBar.withBack({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    bool centerTitle = false,
  }) {
    return CustomAppBar(
      title: title,
      variant: AppBarVariant.withBack,
      onBackPressed: onBackPressed,
      actions: actions,
      centerTitle: centerTitle,
    );
  }

  /// Factory constructor for app bar with search
  factory CustomAppBar.withSearch({
    required String title,
    VoidCallback? onSearchPressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: AppBarVariant.withSearch,
      onSearchPressed: onSearchPressed,
      actions: actions,
    );
  }

  /// Factory constructor for transparent app bar (camera overlay)
  factory CustomAppBar.transparent({
    VoidCallback? onBackPressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      variant: AppBarVariant.transparent,
      onBackPressed: onBackPressed,
      actions: actions,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }

  /// Factory constructor for app bar with profile actions
  factory CustomAppBar.withProfile({
    required String title,
    VoidCallback? onProfilePressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      variant: AppBarVariant.withProfile,
      onProfilePressed: onProfilePressed,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;

    final effectiveBackgroundColor =
        backgroundColor ??
        (variant == AppBarVariant.transparent
            ? Colors.transparent
            : appBarTheme.backgroundColor ?? colorScheme.surface);

    final effectiveForegroundColor =
        foregroundColor ?? appBarTheme.foregroundColor ?? colorScheme.onSurface;

    // System UI overlay style for status bar
    final systemOverlayStyle = variant == AppBarVariant.transparent
        ? SystemUiOverlayStyle.light
        : (theme.brightness == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light);

    return AppBar(
      title: title != null ? Text(title!) : null,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      systemOverlayStyle: systemOverlayStyle,
      leading: _buildLeading(context, effectiveForegroundColor),
      actions: _buildActions(context, effectiveForegroundColor),
      bottom: bottom,
      titleTextStyle: appBarTheme.titleTextStyle?.copyWith(
        color: effectiveForegroundColor,
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, Color foregroundColor) {
    if (leading != null) return leading;

    switch (variant) {
      case AppBarVariant.withBack:
      case AppBarVariant.transparent:
        return IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          tooltip: 'Back',
          iconSize: 24,
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        );
      default:
        return null;
    }
  }

  List<Widget>? _buildActions(BuildContext context, Color foregroundColor) {
    final List<Widget> actionWidgets = [];

    // Add variant-specific actions
    switch (variant) {
      case AppBarVariant.withSearch:
        actionWidgets.add(
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchPressed,
            tooltip: 'Search',
            iconSize: 24,
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        );
        break;
      case AppBarVariant.withProfile:
        actionWidgets.add(
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: onProfilePressed,
            tooltip: 'Profile',
            iconSize: 24,
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        );
        break;
      default:
        break;
    }

    // Add custom actions if provided
    if (actions != null) {
      actionWidgets.addAll(actions!);
    }

    return actionWidgets.isEmpty ? null : actionWidgets;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

/// Common app bar action buttons for reuse across the app
class AppBarActions {
  AppBarActions._();

  /// Notification bell icon with badge support
  static Widget notification({
    required VoidCallback onPressed,
    int? badgeCount,
  }) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: onPressed,
          tooltip: 'Notifications',
          iconSize: 24,
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        ),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFF44336), // Error color for notifications
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  /// More options menu icon
  static Widget moreOptions({required VoidCallback onPressed}) {
    return IconButton(
      icon: const Icon(Icons.more_vert),
      onPressed: onPressed,
      tooltip: 'More options',
      iconSize: 24,
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }

  /// Filter icon for data filtering
  static Widget filter({
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return IconButton(
      icon: Icon(isActive ? Icons.filter_alt : Icons.filter_alt_outlined),
      onPressed: onPressed,
      tooltip: 'Filter',
      iconSize: 24,
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }

  /// Sync/refresh icon for data synchronization
  static Widget sync({
    required VoidCallback onPressed,
    bool isSyncing = false,
  }) {
    return IconButton(
      icon: Icon(isSyncing ? Icons.sync : Icons.sync_outlined),
      onPressed: isSyncing ? null : onPressed,
      tooltip: 'Sync',
      iconSize: 24,
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }

  /// Help/info icon
  static Widget help({required VoidCallback onPressed}) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      onPressed: onPressed,
      tooltip: 'Help',
      iconSize: 24,
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
