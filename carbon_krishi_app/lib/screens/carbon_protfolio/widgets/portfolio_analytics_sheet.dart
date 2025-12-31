import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Bottom sheet displaying comprehensive portfolio analytics
class PortfolioAnalyticsSheet extends StatelessWidget {
  final Map<String, dynamic> analyticsData;

  const PortfolioAnalyticsSheet({super.key, required this.analyticsData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          SizedBox(height: 1.h),
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio Analytics',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(height: 2.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMetricCard(
                    context,
                    'Total ROI',
                    '${(analyticsData['totalROI'] as double).toStringAsFixed(2)}%',
                    'Since inception',
                    (analyticsData['totalROI'] as double) >= 0,
                  ),
                  SizedBox(height: 2.h),
                  _buildMetricCard(
                    context,
                    'Carbon Impact',
                    '${analyticsData['carbonImpact']} tons CO₂',
                    'Total offset',
                    true,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Diversification Breakdown',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  SizedBox(
                    height: 30.h,
                    child: Semantics(
                      label: 'Portfolio Diversification Pie Chart',
                      child: PieChart(
                        PieChartData(
                          sections: _buildPieChartSections(
                            context,
                            analyticsData['diversification']
                                as List<Map<String, dynamic>>,
                          ),
                          sectionsSpace: 2,
                          centerSpaceRadius: 15.w,
                          pieTouchData: PieTouchData(
                            touchCallback:
                                (FlTouchEvent event, pieTouchResponse) {},
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildDiversificationLegend(
                    context,
                    analyticsData['diversification']
                        as List<Map<String, dynamic>>,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'AI Recommendations',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...(analyticsData['recommendations'] as List<String>).map(
                    (recommendation) =>
                        _buildRecommendationCard(context, recommendation),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    bool isPositive,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPositive
                  ? AppTheme.successLight
                  : theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(
    BuildContext context,
    List<Map<String, dynamic>> diversification,
  ) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      AppTheme.successLight,
      AppTheme.warningLight,
    ];

    return List.generate(diversification.length, (index) {
      final item = diversification[index];
      return PieChartSectionData(
        value: item['percentage'] as double,
        title: '${(item['percentage'] as double).toStringAsFixed(1)}%',
        color: colors[index % colors.length],
        radius: 20.w,
        titleStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      );
    });
  }

  Widget _buildDiversificationLegend(
    BuildContext context,
    List<Map<String, dynamic>> diversification,
  ) {
    final theme = Theme.of(context);
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      AppTheme.successLight,
      AppTheme.warningLight,
    ];

    return Column(
      children: List.generate(diversification.length, (index) {
        final item = diversification[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 1.h),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: colors[index % colors.length],
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  item['category'] as String,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '\$${(item['value'] as double).toStringAsFixed(2)}',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String recommendation) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'lightbulb_outline',
            color: theme.colorScheme.secondary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              recommendation,
              style: theme.textTheme.bodyMedium,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
