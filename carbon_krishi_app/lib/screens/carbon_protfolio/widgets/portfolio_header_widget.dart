import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Portfolio header displaying total value and performance metrics
class PortfolioHeaderWidget extends StatelessWidget {
  final double totalValue;
  final double percentageChange;
  final bool isPositive;
  final VoidCallback onRefresh;

  const PortfolioHeaderWidget({
    super.key,
    required this.totalValue,
    required this.percentageChange,
    required this.isPositive,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Portfolio Value',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'refresh',
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
                onPressed: onRefresh,
                tooltip: 'Refresh portfolio',
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${totalValue.toStringAsFixed(2)}',
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: isPositive
                  ? AppTheme.successLight.withValues(alpha: 0.2)
                  : AppTheme.errorLight.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: isPositive ? 'trending_up' : 'trending_down',
                  color: isPositive
                      ? AppTheme.successLight
                      : AppTheme.errorLight,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${isPositive ? '+' : ''}${percentageChange.toStringAsFixed(2)}%',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: isPositive
                        ? AppTheme.successLight
                        : AppTheme.errorLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 1.w),
                Text(
                  'Today',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
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
