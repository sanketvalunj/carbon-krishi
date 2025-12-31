import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sizer/sizer.dart';
import 'package:universal_html/html.dart' as html;

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/analytics_card_widget.dart';
import './widgets/holding_card_widget.dart';
import './widgets/portfolio_analytics_sheet.dart';
import './widgets/portfolio_header_widget.dart';
import './widgets/transaction_item_widget.dart';

class CarbonPortfolio extends StatefulWidget {
  const CarbonPortfolio({super.key});

  @override
  State<CarbonPortfolio> createState() => _CarbonPortfolioState();
}

class _CarbonPortfolioState extends State<CarbonPortfolio>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;
  int _currentBottomNavIndex = 3;

  // Mock portfolio data
  final List<Map<String, dynamic>> _holdings = [
    {
      "id": 1,
      "projectName": "Amazon Rainforest Conservation",
      "quantity": 150,
      "currentValue": 4500.00,
      "purchasePrice": 4200.00,
      "gainLoss": 300.00,
      "changePercentage": 7.14,
    },
    {
      "id": 2,
      "projectName": "Solar Farm Development - India",
      "quantity": 200,
      "currentValue": 5800.00,
      "purchasePrice": 6000.00,
      "gainLoss": -200.00,
      "changePercentage": -3.33,
    },
    {
      "id": 3,
      "projectName": "Wind Energy Project - Denmark",
      "quantity": 100,
      "currentValue": 3200.00,
      "purchasePrice": 3000.00,
      "gainLoss": 200.00,
      "changePercentage": 6.67,
    },
    {
      "id": 4,
      "projectName": "Reforestation Initiative - Kenya",
      "quantity": 75,
      "currentValue": 2100.00,
      "purchasePrice": 2250.00,
      "gainLoss": -150.00,
      "changePercentage": -6.67,
    },
    {
      "id": 5,
      "projectName": "Ocean Cleanup Technology",
      "quantity": 120,
      "currentValue": 3600.00,
      "purchasePrice": 3400.00,
      "gainLoss": 200.00,
      "changePercentage": 5.88,
    },
  ];

  final List<Map<String, dynamic>> _transactions = [
    {
      "id": 1,
      "projectName": "Amazon Rainforest Conservation",
      "type": "Buy",
      "quantity": 150,
      "amount": 4200.00,
      "date": "Dec 15, 2024",
      "status": "Completed",
    },
    {
      "id": 2,
      "projectName": "Solar Farm Development - India",
      "type": "Buy",
      "quantity": 200,
      "amount": 6000.00,
      "date": "Dec 10, 2024",
      "status": "Completed",
    },
    {
      "id": 3,
      "projectName": "Wind Energy Project - Denmark",
      "type": "Sell",
      "quantity": 50,
      "amount": 1600.00,
      "date": "Dec 20, 2024",
      "status": "Completed",
    },
    {
      "id": 4,
      "projectName": "Reforestation Initiative - Kenya",
      "type": "Buy",
      "quantity": 75,
      "amount": 2250.00,
      "date": "Dec 5, 2024",
      "status": "Completed",
    },
    {
      "id": 5,
      "projectName": "Ocean Cleanup Technology",
      "type": "Buy",
      "quantity": 120,
      "amount": 3400.00,
      "date": "Dec 1, 2024",
      "status": "Pending",
    },
  ];

  final Map<String, dynamic> _analyticsData = {
    "totalROI": 15.42,
    "carbonImpact": 1250,
    "diversification": [
      {"category": "Renewable Energy", "percentage": 35.0, "value": 6800.00},
      {"category": "Forest Conservation", "percentage": 30.0, "value": 5850.00},
      {"category": "Ocean Protection", "percentage": 20.0, "value": 3900.00},
      {
        "category": "Sustainable Agriculture",
        "percentage": 10.0,
        "value": 1950.00,
      },
      {"category": "Clean Technology", "percentage": 5.0, "value": 975.00},
    ],
    "recommendations": [
      "Consider diversifying into emerging carbon markets in Southeast Asia",
      "Your renewable energy holdings show strong performance - consider increasing allocation",
      "Ocean protection credits are undervalued - good opportunity for long-term growth",
      "Rebalance portfolio to reduce exposure to volatile forest conservation projects",
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get _totalPortfolioValue {
    return _holdings.fold(
      0.0,
      (sum, holding) => sum + (holding['currentValue'] as double),
    );
  }

  double get _totalPercentageChange {
    final totalGainLoss = _holdings.fold(
      0.0,
      (sum, holding) => sum + (holding['gainLoss'] as double),
    );
    final totalPurchasePrice = _holdings.fold(
      0.0,
      (sum, holding) => sum + (holding['purchasePrice'] as double),
    );
    return totalPurchasePrice > 0
        ? (totalGainLoss / totalPurchasePrice) * 100
        : 0.0;
  }

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.mediumImpact();

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);

    Fluttertoast.showToast(
      msg: "Portfolio updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  void _showAnalyticsSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          PortfolioAnalyticsSheet(analyticsData: _analyticsData),
    );
  }

  Future<void> _exportPortfolio() async {
    HapticFeedback.mediumImpact();

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Carbon Portfolio Report',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total Portfolio Value: \$${_totalPortfolioValue.toStringAsFixed(2)}',
                ),
                pw.Text(
                  'Total ROI: ${_totalPercentageChange.toStringAsFixed(2)}%',
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Holdings:',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                ..._holdings.map(
                  (holding) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Text(
                      '${holding['projectName']}: ${holding['quantity']} credits - \$${(holding['currentValue'] as double).toStringAsFixed(2)}',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      final filename =
          'carbon_portfolio_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        final blob = html.Blob([pdfBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$filename');
        await file.writeAsBytes(pdfBytes);
      }

      Fluttertoast.showToast(
        msg: "Portfolio exported successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to export portfolio",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  void _handleAddInvestment() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/carbon-dashboard');
  }

  void _handleSellHolding(Map<String, dynamic> holding) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sell Credits'),
        content: Text(
          'Sell ${holding['quantity']} credits from ${holding['projectName']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "Sell order placed successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black87,
                textColor: Colors.white,
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _handleTransferHolding(Map<String, dynamic> holding) {
    HapticFeedback.mediumImpact();
    Fluttertoast.showToast(
      msg: "Transfer feature coming soon",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  void _handleViewDetails(Map<String, dynamic> holding) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildHoldingDetailsSheet(holding),
    );
  }

  void _handleViewChart(Map<String, dynamic> holding) {
    HapticFeedback.lightImpact();
    Fluttertoast.showToast(
      msg: "Opening performance chart",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  Widget _buildHoldingDetailsSheet(Map<String, dynamic> holding) {
    final theme = Theme.of(context);

    return Container(
      height: 60.h,
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
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: 2.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    holding['projectName'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                  _buildDetailRow(
                    context,
                    'Quantity',
                    '${holding['quantity']} Credits',
                  ),
                  _buildDetailRow(
                    context,
                    'Current Value',
                    '\$${(holding['currentValue'] as double).toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(
                    context,
                    'Purchase Price',
                    '\$${(holding['purchasePrice'] as double).toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(
                    context,
                    'Gain/Loss',
                    '\$${(holding['gainLoss'] as double).toStringAsFixed(2)}',
                    isHighlighted: true,
                    isPositive: (holding['gainLoss'] as double) >= 0,
                  ),
                  _buildDetailRow(
                    context,
                    'Change',
                    '${(holding['changePercentage'] as double).toStringAsFixed(2)}%',
                    isHighlighted: true,
                    isPositive: (holding['changePercentage'] as double) >= 0,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleSellHolding(holding);
                          },
                          child: const Text('Sell'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _handleTransferHolding(holding);
                          },
                          child: const Text('Transfer'),
                        ),
                      ),
                    ],
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

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
    bool isPositive = true,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isHighlighted
                  ? (isPositive ? AppTheme.successLight : AppTheme.errorLight)
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Portfolio',
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: _exportPortfolio,
            tooltip: 'Export Portfolio',
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: _showAnalyticsSheet,
            tooltip: 'View Analytics',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Column(
          children: [
            PortfolioHeaderWidget(
              totalValue: _totalPortfolioValue,
              percentageChange: _totalPercentageChange,
              isPositive: _totalPercentageChange >= 0,
              onRefresh: _handleRefresh,
            ),
            Container(
              color: theme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Holdings'),
                  Tab(text: 'Transactions'),
                  Tab(text: 'Analytics'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildHoldingsTab(),
                  _buildTransactionsTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleAddInvestment,
        icon: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 24,
        ),
        label: const Text('Add Investment'),
      ),
    );
  }

  Widget _buildHoldingsTab() {
    return _holdings.isEmpty
        ? _buildEmptyState(
            'No holdings yet',
            'Start investing in carbon credits',
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            itemCount: _holdings.length,
            itemBuilder: (context, index) {
              final holding = _holdings[index];
              return HoldingCardWidget(
                holding: holding,
                onTap: () => _handleViewDetails(holding),
                onSell: () => _handleSellHolding(holding),
                onTransfer: () => _handleTransferHolding(holding),
                onViewDetails: () => _handleViewDetails(holding),
                onViewChart: () => _handleViewChart(holding),
              );
            },
          );
  }

  Widget _buildTransactionsTab() {
    return _transactions.isEmpty
        ? _buildEmptyState(
            'No transactions yet',
            'Your transaction history will appear here',
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              return TransactionItemWidget(transaction: _transactions[index]);
            },
          );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: [
          AnalyticsCardWidget(
            title: 'Total ROI',
            value: '${_analyticsData['totalROI']}%',
            subtitle: 'Since inception',
            chartData: [100, 105, 103, 108, 112, 115, 115.42],
            isPositive: (_analyticsData['totalROI'] as double) >= 0,
          ),
          AnalyticsCardWidget(
            title: 'Carbon Impact',
            value: '${_analyticsData['carbonImpact']} tons',
            subtitle: 'CO₂ offset',
            chartData: [0, 200, 450, 700, 950, 1100, 1250],
            isPositive: true,
          ),
          AnalyticsCardWidget(
            title: 'Portfolio Growth',
            value: '\$${_totalPortfolioValue.toStringAsFixed(2)}',
            subtitle:
                '${_totalPercentageChange >= 0 ? '+' : ''}${_totalPercentageChange.toStringAsFixed(2)}% this month',
            chartData: [
              18000,
              18500,
              18200,
              19000,
              19200,
              19400,
              _totalPortfolioValue,
            ],
            isPositive: _totalPercentageChange >= 0,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'pie_chart_outline',
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.3),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
