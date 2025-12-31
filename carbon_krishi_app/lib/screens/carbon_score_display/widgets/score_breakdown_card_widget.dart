import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../core/app_export.dart';

class ScoreBreakdownCardWidget extends StatelessWidget {
  final String category;
  final double score;
  final double credits;
  final Color color;
  final String icon;
  final String description;
  final String language;

  const ScoreBreakdownCardWidget({
    super.key,
    required this.category,
    required this.score,
    required this.credits,
    required this.color,
    required this.icon,
    required this.description,
    required this.language,
  });

  String _translateCategory(String category) {
    if (language != 'Hindi') return category;
    final translations = {
      'Tree Planting': 'वृक्षारोपण',
      'Sustainable Practices': 'टिकाऊ प्रथाएं',
      'Reduced Emissions': 'कम उत्सर्जन',
      'Soil Health': 'मिट्टी स्वास्थ्य',
    };
    return translations[category] ?? category;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(_translateCategory(category)),
              content: Text(description),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(language == 'Hindi' ? 'बंद करें' : 'Close'),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: CustomIconWidget(
                      iconName: icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _translateCategory(category),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          language == 'Hindi'
                              ? '₹${credits.toStringAsFixed(2)} अर्जित'
                              : '₹${credits.toStringAsFixed(2)} earned',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        score.toStringAsFixed(1),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        language == 'Hindi' ? 'स्कोर' : 'Score',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearPercentIndicator(
                padding: EdgeInsets.zero,
                lineHeight: 8,
                percent: score / 100,
                backgroundColor: color.withValues(alpha: 0.2),
                progressColor: color,
                barRadius: const Radius.circular(4),
                animation: true,
                animationDuration: 1000,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
