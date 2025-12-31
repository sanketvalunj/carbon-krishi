import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AchievementTimelineWidget extends StatelessWidget {
  final List<dynamic> achievements;
  final String language;

  const AchievementTimelineWidget({
    super.key,
    required this.achievements,
    required this.language,
  });

  String _translateTitle(String title) {
    if (language != 'Hindi') return title;
    final translations = {
      'First 100 Trees': 'पहले 100 पेड़',
      'Silver Level Reached': 'सिल्वर स्तर प्राप्त',
      'Top 10% in Region': 'क्षेत्र में शीर्ष 10%',
    };
    return translations[title] ?? title;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'emoji_events',
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  language == 'Hindi' ? 'उपलब्धियां' : 'Achievements',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...achievements.asMap().entries.map((entry) {
              final index = entry.key;
              final achievement = entry.value;
              final isLast = index == achievements.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(
                              achievement["color"],
                            ).withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(achievement["color"]),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: achievement["icon"],
                              color: Color(achievement["color"]),
                              size: 24,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(
                                      achievement["color"],
                                    ).withValues(alpha: 0.5),
                                    Color(
                                      achievements[index + 1]["color"],
                                    ).withValues(alpha: 0.5),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _translateTitle(achievement["title"]),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement["date"],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        language == 'Hindi'
                            ? 'सोशल शेयर जल्द आ रहा है'
                            : 'Social sharing coming soon',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  language == 'Hindi'
                      ? 'उपलब्धियां शेयर करें'
                      : 'Share Achievements',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
