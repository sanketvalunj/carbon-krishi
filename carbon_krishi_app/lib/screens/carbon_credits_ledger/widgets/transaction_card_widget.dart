import 'package:intl/intl.dart';

import '../../../../core/app_export.dart';

/// Transaction Card Widget
/// Displays individual transaction information in a card format
class TransactionCardWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final String selectedLanguage;
  final VoidCallback onTap;

  const TransactionCardWidget({
    super.key,
    required this.transaction,
    required this.selectedLanguage,
    required this.onTap,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'Verified':
        return theme.colorScheme.secondary;
      case 'Pending':
        return theme.colorScheme.tertiary;
      case 'Disputed':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    if (selectedLanguage == 'Hindi') {
      switch (status) {
        case 'Verified':
          return 'सत्यापित';
        case 'Pending':
          return 'लंबित';
        case 'Disputed':
          return 'विवादित';
        default:
          return status;
      }
    }
    return status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = transaction['amount'] as double;
    final date = transaction['date'] as DateTime;
    final status = transaction['status'] as String;
    final practiceType = transaction['practiceType'] as String;
    final practiceIcon = transaction['practiceIcon'] as String;
    final description = selectedLanguage == 'Hindi'
        ? transaction['descriptionHindi'] as String
        : transaction['description'] as String;
    final blockchainId = transaction['blockchainId'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Practice Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: practiceIcon,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Practice Type and Amount
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          practiceType,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(amount),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        status,
                        theme,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getStatusColor(
                          status,
                          theme,
                        ).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _getStatusColor(status, theme),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getStatusText(status),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getStatusColor(status, theme),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer Row
              Row(
                children: [
                  // Date
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(date),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),

                  // Blockchain ID (truncated)
                  CustomIconWidget(
                    iconName: 'link',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${blockchainId.substring(0, 10)}...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}