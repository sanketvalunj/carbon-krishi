import 'package:flutter/material.dart';
import '../../../core/app_export.dart';

class CalculationExplanationWidget extends StatelessWidget {
  final String language;

  const CalculationExplanationWidget({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calculate',
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        language == 'Hindi'
                            ? 'स्कोर की गणना कैसे की जाती है?'
                            : 'How is the Score Calculated?',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: theme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildExplanationCard(
                  context,
                  language == 'Hindi' ? 'वृक्षारोपण' : 'Tree Planting',
                  language == 'Hindi'
                      ? 'प्रत्येक पेड़ 0.5 अंक देता है। 150 पेड़ = 75 अंक।'
                      : 'Each tree contributes 0.5 points. 150 trees = 75 points.',
                  'park',
                  const Color(0xFF4CAF50),
                ),
                _buildExplanationCard(
                  context,
                  language == 'Hindi'
                      ? 'टिकाऊ प्रथाएं'
                      : 'Sustainable Practices',
                  language == 'Hindi'
                      ? 'जैविक खेती, फसल चक्र, और कम्पोस्टिंग से अंक मिलते हैं।'
                      : 'Points earned from organic farming, crop rotation, and composting.',
                  'eco',
                  const Color(0xFF66BB6A),
                ),
                _buildExplanationCard(
                  context,
                  language == 'Hindi' ? 'कम उत्सर्जन' : 'Reduced Emissions',
                  language == 'Hindi'
                      ? 'रासायनिक उर्वरक में कमी से अंक बढ़ते हैं।'
                      : 'Reducing chemical fertilizer usage increases points.',
                  'cloud_off',
                  const Color(0xFF81C784),
                ),
                _buildExplanationCard(
                  context,
                  language == 'Hindi' ? 'मिट्टी स्वास्थ्य' : 'Soil Health',
                  language == 'Hindi'
                      ? 'मिट्टी में कार्बन सामग्री बढ़ाने से अंक मिलते हैं।'
                      : 'Improving soil carbon content earns points.',
                  'grass',
                  const Color(0xFF2E7D32),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info_outline',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          language == 'Hindi'
                              ? 'आपका स्कोर हर महीने अपडेट होता है और बाजार दरों के आधार पर कार्बन क्रेडिट में परिवर्तित होता है।'
                              : 'Your score updates monthly and converts to carbon credits based on market rates.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(language == 'Hindi' ? 'समझ गया' : 'Got It'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(
    BuildContext context,
    String title,
    String description,
    String icon,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(iconName: icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
