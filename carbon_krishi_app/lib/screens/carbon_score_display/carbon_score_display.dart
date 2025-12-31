import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/achievement_timeline_widget.dart';
import './widgets/calculation_explanation_widget.dart';
import './widgets/monthly_progress_chart_widget.dart';
import './widgets/projection_card_widget.dart';
import './widgets/score_breakdown_card_widget.dart';

class CarbonScoreDisplay extends StatefulWidget {
  const CarbonScoreDisplay({super.key});

  @override
  State<CarbonScoreDisplay> createState() => _CarbonScoreDisplayState();
}

class _CarbonScoreDisplayState extends State<CarbonScoreDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  bool _isRefreshing = false;
  String _selectedLanguage = 'English';

  // Mock data for carbon score
  final Map<String, dynamic> _carbonScoreData = {
    "overallScore": 78.5,
    "achievementLevel": "Silver",
    "totalCreditsEarned": 245.50,
    "lastUpdated": "2025-12-29",
    "breakdown": [
      {
        "category": "Tree Planting",
        "score": 85.0,
        "credits": 95.25,
        "color": 0xFF4CAF50,
        "icon": "park",
        "description":
            "Excellent contribution through planting 150 trees this season",
      },
      {
        "category": "Sustainable Practices",
        "score": 75.0,
        "credits": 82.50,
        "color": 0xFF66BB6A,
        "icon": "eco",
        "description": "Good adoption of organic farming and crop rotation",
      },
      {
        "category": "Reduced Emissions",
        "score": 70.0,
        "credits": 45.75,
        "color": 0xFF81C784,
        "icon": "cloud_off",
        "description": "Reduced chemical fertilizer usage by 40%",
      },
      {
        "category": "Soil Health",
        "score": 82.0,
        "credits": 22.00,
        "color": 0xFF2E7D32,
        "icon": "grass",
        "description": "Improved soil carbon content through composting",
      },
    ],
    "monthlyProgress": [
      {"month": "Jul", "score": 65.0},
      {"month": "Aug", "score": 68.5},
      {"month": "Sep", "score": 72.0},
      {"month": "Oct", "score": 75.5},
      {"month": "Nov", "score": 76.8},
      {"month": "Dec", "score": 78.5},
    ],
    "regionalAverage": 62.3,
    "achievements": [
      {
        "title": "First 100 Trees",
        "date": "2025-08-15",
        "icon": "emoji_events",
        "color": 0xFFFFB74D,
      },
      {
        "title": "Silver Level Reached",
        "date": "2025-11-20",
        "icon": "military_tech",
        "color": 0xFFC0C0C0,
      },
      {
        "title": "Top 10% in Region",
        "date": "2025-12-10",
        "icon": "star",
        "color": 0xFFFFD700,
      },
    ],
    "projections": [
      {
        "title": "Next Month Potential",
        "estimatedScore": 82.0,
        "estimatedCredits": 275.00,
        "actions": [
          "Plant 20 more trees",
          "Complete organic certification",
          "Reduce water usage by 15%",
        ],
      },
      {
        "title": "Gold Level Target",
        "estimatedScore": 90.0,
        "estimatedCredits": 450.00,
        "actions": [
          "Achieve 85+ score for 3 months",
          "Plant 200+ trees total",
          "Zero chemical fertilizer usage",
        ],
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scoreAnimation =
        Tween<double>(
          begin: 0.0,
          end: _carbonScoreData["overallScore"] / 100,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 2));
    _animationController.reset();
    _animationController.forward();
    setState(() => _isRefreshing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _selectedLanguage == 'Hindi'
                ? 'डेटा अपडेट हो गया'
                : 'Data updated successfully',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareScore() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selectedLanguage == 'Hindi'
              ? 'स्कोर शेयर करने की सुविधा जल्द आ रही है'
              : 'Share functionality coming soon',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCalculationHelp() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CalculationExplanationWidget(language: _selectedLanguage),
    );
  }

  Color _getAchievementColor(String level) {
    switch (level.toLowerCase()) {
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar.withBack(
        title: _selectedLanguage == 'Hindi' ? 'कार्बन स्कोर' : 'Carbon Score',
        onBackPressed: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _shareScore,
            tooltip: _selectedLanguage == 'Hindi' ? 'शेयर करें' : 'Share',
          ),
          PopupMenuButton<String>(
            icon: CustomIconWidget(
              iconName: 'language',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onSelected: (value) => setState(() => _selectedLanguage = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'English', child: Text('English')),
              const PopupMenuItem(value: 'Hindi', child: Text('हिंदी')),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Main Score Section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    // Circular Progress Indicator
                    AnimatedBuilder(
                      animation: _scoreAnimation,
                      builder: (context, child) {
                        return CircularPercentIndicator(
                          radius: 120,
                          lineWidth: 20,
                          percent: _scoreAnimation.value,
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                (_scoreAnimation.value * 100).toStringAsFixed(
                                  1,
                                ),
                                style: theme.textTheme.displayLarge?.copyWith(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                _selectedLanguage == 'Hindi'
                                    ? 'स्कोर'
                                    : 'Score',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          progressColor: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          animation: false,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    // Achievement Level Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _getAchievementColor(
                          _carbonScoreData["achievementLevel"],
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: _getAchievementColor(
                            _carbonScoreData["achievementLevel"],
                          ),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'military_tech',
                            color: _getAchievementColor(
                              _carbonScoreData["achievementLevel"],
                            ),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedLanguage == 'Hindi'
                                ? '${_carbonScoreData["achievementLevel"]} स्तर'
                                : '${_carbonScoreData["achievementLevel"]} Level',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: _getAchievementColor(
                                _carbonScoreData["achievementLevel"],
                              ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Credits Earned
                    Text(
                      _selectedLanguage == 'Hindi'
                          ? '₹${_carbonScoreData["totalCreditsEarned"].toStringAsFixed(2)} अर्जित'
                          : '₹${_carbonScoreData["totalCreditsEarned"].toStringAsFixed(2)} Earned',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedLanguage == 'Hindi'
                          ? 'अंतिम अपडेट: ${_carbonScoreData["lastUpdated"]}'
                          : 'Last Updated: ${_carbonScoreData["lastUpdated"]}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Score Breakdown Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedLanguage == 'Hindi'
                              ? 'स्कोर विवरण'
                              : 'Score Breakdown',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showCalculationHelp,
                          icon: CustomIconWidget(
                            iconName: 'help_outline',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          label: Text(
                            _selectedLanguage == 'Hindi'
                                ? 'कैसे गणना की जाती है?'
                                : 'How is it calculated?',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...(_carbonScoreData["breakdown"] as List)
                        .map(
                          (item) => ScoreBreakdownCardWidget(
                            category: item["category"],
                            score: item["score"],
                            credits: item["credits"],
                            color: Color(item["color"]),
                            icon: item["icon"],
                            description: item["description"],
                            language: _selectedLanguage,
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),

              // Monthly Progress Chart
              Padding(
                padding: const EdgeInsets.all(16),
                child: MonthlyProgressChartWidget(
                  monthlyData: _carbonScoreData["monthlyProgress"],
                  regionalAverage: _carbonScoreData["regionalAverage"],
                  language: _selectedLanguage,
                ),
              ),

              // Achievement Timeline
              Padding(
                padding: const EdgeInsets.all(16),
                child: AchievementTimelineWidget(
                  achievements: _carbonScoreData["achievements"],
                  language: _selectedLanguage,
                ),
              ),

              // Projection Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedLanguage == 'Hindi'
                          ? 'आपकी संभावनाएं'
                          : 'Your Potential',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...(_carbonScoreData["projections"] as List)
                        .map(
                          (projection) => ProjectionCardWidget(
                            title: projection["title"],
                            estimatedScore: projection["estimatedScore"],
                            estimatedCredits: projection["estimatedCredits"],
                            actions: projection["actions"],
                            language: _selectedLanguage,
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
