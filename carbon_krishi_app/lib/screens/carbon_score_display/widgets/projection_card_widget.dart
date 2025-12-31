import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProjectionCardWidget extends StatelessWidget {
  final String title;
  final double estimatedScore;
  final double estimatedCredits;
  final List<dynamic> actions;
  final String language;

  const ProjectionCardWidget({
    super.key,
    required this.title,
    required this.estimatedScore,
    required this.estimatedCredits,
    required this.actions,
    required this.language,
  });

  String _translateTitle(String title) {
    if (language != 'Hindi') return title;
    final translations = {
      'Next Month Potential': 'अगले महीने की संभावना',
      'Gold Level Target': 'गोल्ड स्तर लक्ष्य',
    };
    return translations[title] ?? title;
  }

  String _translateAction(String action) {
    if (language != 'Hindi') return action;
    final translations = {
      'Plant 20 more trees': '20 और पेड़ लगाएं',
      'Complete organic certification': 'जैविक प्रमाणन पूरा करें',
      'Reduce water usage by 15%': 'पानी का उपयोग 15% कम करें',
      'Achieve 85+ score for 3 months': '3 महीने के लिए 85+ स्कोर प्राप्त करें',
      'Plant 200+ trees total': 'कुल 200+ पेड़ लगाएं',
      'Zero chemical fertilizer usage': 'शून्य रासायनिक उर्वरक उपयोग',
    };
    return translations[action] ?? action;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGoldTarget = title.contains('Gold');

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isGoldTarget
            ? BorderSide(
                color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: Container(
        decoration: isGoldTarget
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFD700).withValues(alpha: 0.1),
                    theme.colorScheme.surface,
                  ],
                ),
              )
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isGoldTarget
                          ? const Color(0xFFFFD700).withValues(alpha: 0.2)
                          : theme.colorScheme.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: isGoldTarget ? 'emoji_events' : 'trending_up',
                      color: isGoldTarget
                          ? const Color(0xFFFFD700)
                          : theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _translateTitle(title),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      language == 'Hindi' ? 'अनुमानित स्कोर' : 'Est. Score',
                      estimatedScore.toStringAsFixed(1),
                      'stars',
                      theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      context,
                      language == 'Hindi' ? 'अनुमानित क्रेडिट' : 'Est. Credits',
                      '₹${estimatedCredits.toStringAsFixed(0)}',
                      'account_balance_wallet',
                      theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                language == 'Hindi' ? 'आवश्यक कार्य:' : 'Required Actions:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...actions.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _translateAction(entry.value),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          language == 'Hindi'
                              ? 'कार्य योजना जल्द आ रही है'
                              : 'Action plan coming soon',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  label: Text(
                    language == 'Hindi'
                        ? 'कार्य योजना देखें'
                        : 'View Action Plan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    String icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(iconName: icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
