import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual carbon credit holding card with swipe actions
class HoldingCardWidget extends StatelessWidget {
  final Map<String, dynamic> holding;
  final VoidCallback onTap;
  final VoidCallback onSell;
  final VoidCallback onTransfer;
  final VoidCallback onViewDetails;
  final VoidCallback onViewChart;

  const HoldingCardWidget({
    super.key,
    required this.holding,
    required this.onTap,
    required this.onSell,
    required this.onTransfer,
    required this.onViewDetails,
    required this.onViewChart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPositive = (holding['changePercentage'] as double) >= 0;

    return Slidable(
      key: ValueKey(holding['id']),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.mediumImpact();
              onSell();
            },
            backgroundColor: AppTheme.errorLight,
            foregroundColor: Colors.white,
            icon: Icons.sell,
            label: 'Sell',
          ),
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.mediumImpact();
              onTransfer();
            },
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.swap_horiz,
            label: 'Transfer',
          ),
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.mediumImpact();
              onViewDetails();
            },
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.info_outline,
            label: 'Details',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              HapticFeedback.mediumImpact();
              onViewChart();
            },
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: Colors.white,
            icon: Icons.show_chart,
            label: 'Chart',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'eco',
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holding['projectName'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            '${holding['quantity']} Credits',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(holding['currentValue'] as double).toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 0.3.h,
                          ),
                          decoration: BoxDecoration(
                            color: isPositive
                                ? AppTheme.successLight.withValues(alpha: 0.1)
                                : AppTheme.errorLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: isPositive
                                    ? 'arrow_upward'
                                    : 'arrow_downward',
                                color: isPositive
                                    ? AppTheme.successLight
                                    : AppTheme.errorLight,
                                size: 12,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                '${(holding['changePercentage'] as double).abs().toStringAsFixed(2)}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isPositive
                                      ? AppTheme.successLight
                                      : AppTheme.errorLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoChip(
                        context,
                        'Purchase Price',
                        '\$${(holding['purchasePrice'] as double).toStringAsFixed(2)}',
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: _buildInfoChip(
                        context,
                        'Gain/Loss',
                        '\$${(holding['gainLoss'] as double).toStringAsFixed(2)}',
                        isPositive: isPositive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    BuildContext context,
    String label,
    String value, {
    bool? isPositive,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.3.h),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isPositive != null
                  ? (isPositive ? AppTheme.successLight : AppTheme.errorLight)
                  : theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
