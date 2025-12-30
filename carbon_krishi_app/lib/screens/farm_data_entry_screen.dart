import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ndvi.dart';
import '../services/api_service.dart';

class FarmDataEntryScreen extends StatefulWidget {
  const FarmDataEntryScreen({super.key});

  @override
  State<FarmDataEntryScreen> createState() => _FarmDataEntryScreenState();
}

class _FarmDataEntryScreenState extends State<FarmDataEntryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _farmSizeController = TextEditingController();
  final _fertilizerQtyController = TextEditingController();

  String _selectedCrop = 'Rice';
  String _selectedSeason = 'Kharif';
  String _selectedFertilizer = 'Organic';
  String _selectedTilling = 'No-Till';
  String _selectedIrrigation = 'Solar';
  String _selectedResidue = 'Composting';
  int _treesPlanted = 0;
  bool _useCompost = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Farm Data'),
        backgroundColor: const Color(0xFF2E7D32),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Basic Info'),
            Tab(text: 'Practices'),
            Tab(text: 'Sustainability'),
            Tab(text: 'NDVI Preview'),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: Form(
        key: _formKey,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildBasicInfoTab(),
            _buildPracticesTab(),
            _buildSustainabilityTab(),
            _buildNDVIPreviewTab(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF2E7D32),
          ),
          child: const Text('Save Farm Data', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Farm Size',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _farmSizeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter farm size in acres',
              prefixIcon: const Icon(Icons.landscape, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Crop Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedCrop,
            items: [
              'Rice',
              'Wheat',
              'Sugarcane',
              'Cotton',
              'Maize',
              'Vegetables',
            ],
            onChanged: (value) => setState(() => _selectedCrop = value!),
            icon: Icons.grass,
          ),
          const SizedBox(height: 24),

          const Text(
            'Season',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedSeason,
            items: ['Kharif', 'Rabi', 'Zaid'],
            onChanged: (value) => setState(() => _selectedSeason = value!),
            icon: Icons.wb_sunny,
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Location detected: Pimpri, Maharashtra'),
                ),
              );
            },
            icon: const Icon(Icons.my_location),
            label: const Text('Auto-Detect Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E7D32),
              side: const BorderSide(color: Color(0xFF2E7D32)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fertilizer Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedFertilizer,
            items: ['Organic', 'Chemical', 'Mixed', 'None'],
            onChanged: (value) => setState(() => _selectedFertilizer = value!),
            icon: Icons.science,
          ),
          const SizedBox(height: 24),

          const Text(
            'Fertilizer Quantity (kg)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _fertilizerQtyController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter quantity',
              prefixIcon: const Icon(Icons.scale, color: Color(0xFF2E7D32)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Tilling Method',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildRadioTiles(
            ['No-Till', 'Reduced Till', 'Conventional'],
            _selectedTilling,
            (value) => setState(() => _selectedTilling = value!),
          ),
          const SizedBox(height: 24),

          const Text(
            'Irrigation Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildRadioTiles(
            ['Solar', 'Electric', 'Diesel'],
            _selectedIrrigation,
            (value) => setState(() => _selectedIrrigation = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildSustainabilityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trees Planted',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (_treesPlanted > 0) {
                    setState(() => _treesPlanted--);
                  }
                },
                icon: const Icon(Icons.remove_circle),
                color: const Color(0xFFE53935),
                iconSize: 40,
              ),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF2E7D32)),
                ),
                child: Text(
                  '$_treesPlanted',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              IconButton(
                onPressed: () => setState(() => _treesPlanted++),
                icon: const Icon(Icons.add_circle),
                color: const Color(0xFF2E7D32),
                iconSize: 40,
              ),
            ],
          ),
          const SizedBox(height: 32),

          const Text(
            'Crop Residue Management',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _buildDropdown(
            value: _selectedResidue,
            items: ['Composting', 'Mulching', 'Burning', 'Removal'],
            onChanged: (value) => setState(() => _selectedResidue = value!),
            icon: Icons.recycling,
          ),
          const SizedBox(height: 24),

          const Text(
            'Compost Usage',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            value: _useCompost,
            onChanged: (value) => setState(() => _useCompost = value),
            title: const Text('Use Compost'),
            subtitle: Text(
              _useCompost ? 'Currently using compost' : 'Not using compost',
            ),
            activeThumbColor: const Color(0xFF2E7D32),
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF66BB6A)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info, color: Color(0xFF2E7D32)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'More sustainable practices = More carbon credits!',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
      ),
    );
  }

  Widget _buildRadioTiles(
    List<String> options,
    String selected,
    Function(String?) onChanged,
  ) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          value: option,
          groupValue: selected,
          onChanged: onChanged,
          title: Text(option),
          activeColor: const Color(0xFF2E7D32),
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Farm data saved successfully! ✅'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
      // Prepare data to return to caller
      final data = {
        'farmSize': _farmSizeController.text.isNotEmpty
            ? double.tryParse(_farmSizeController.text) ?? 0.0
            : 0.0,
        'cropType': _selectedCrop,
        'season': _selectedSeason,
        'fertilizerType': _selectedFertilizer,
        'fertilizerQty': _fertilizerQtyController.text.isNotEmpty
            ? double.tryParse(_fertilizerQtyController.text) ?? 0.0
            : 0.0,
        'tilling': _selectedTilling,
        'irrigation': _selectedIrrigation,
        'treesPlanted': _treesPlanted,
        'useCompost': _useCompost,
        'ndvi': _ndviData?.ndvi ?? 0.0,
      };

      Navigator.pop(context, data);
    }
  }

  Widget _buildNDVIPreviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'NDVI Preview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Preview the estimated NDVI (Normalized Difference Vegetation Index) for your farm based on the data entered above.',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 32),

          Center(
            child: ElevatedButton.icon(
              onPressed: _generateNDVIPreview,
              icon: const Icon(Icons.visibility),
              label: const Text('Generate NDVI Preview'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // NDVI Display Area (will be populated after API call)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2E7D32)),
            ),
            child: Column(
              children: [
                const Icon(Icons.grass, size: 48, color: Color(0xFF2E7D32)),
                const SizedBox(height: 16),
                const Text(
                  'NDVI Value',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  _ndviData != null ? _formatNDVIValue(_ndviData!.ndvi) : '--',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _ndviData != null
                      ? 'Health: ${_ndviData!.healthStatus}'
                      : 'Health: --',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                if (_ndviData != null &&
                    _ndviData!.contributingFactors.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Contributing Factors:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ..._buildContributingFactorsList(),
                ],
              ],
            ),
          ),

          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2196F3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF2196F3)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'NDVI indicates vegetation health. Higher values (closer to 1) suggest healthier crops and better carbon sequestration potential.',
                    style: TextStyle(color: Color(0xFF1565C0), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  NDVI? _ndviData;
  bool _isLoadingNDVI = false;

  void _generateNDVIPreview() async {
    setState(() {
      _isLoadingNDVI = true;
    });

    try {
      // Prepare farm data for submission
      final farmData = {
        'farm_size': _farmSizeController.text.isNotEmpty
            ? double.tryParse(_farmSizeController.text) ?? 0.0
            : 0.0,
        'crop_type': _selectedCrop,
        'season': _selectedSeason,
        'fertilizer_type': _selectedFertilizer,
        'fertilizer_quantity': _fertilizerQtyController.text.isNotEmpty
            ? double.tryParse(_fertilizerQtyController.text) ?? 0.0
            : 0.0,
        'tilling_method': _selectedTilling,
        'irrigation_type': _selectedIrrigation,
        'trees_planted': _treesPlanted,
        'crop_residue_method': _selectedResidue,
        'use_compost': _useCompost,
        'location': {
          'latitude': 18.5204, // Default coordinates for demo
          'longitude': 73.8567,
        },
      };

      // Try to submit farm data to backend
      try {
        final response = await http
            .post(
              Uri.parse('${ApiService.baseUrl}/api/farms/data'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(farmData),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final farmId = responseData['farm_id'];

          // Fetch NDVI data from backend
          final ndvi = await ApiService.getNDVI(farmId);

          setState(() {
            _ndviData = ndvi;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('NDVI preview generated successfully!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
          setState(() {
            _isLoadingNDVI = false;
          });
          return;
        }
      } catch (backendError) {
        // Backend not available, generate mock NDVI data
        print('Backend not available: $backendError');
      }

      // Generate mock NDVI data when backend is not available
      final mockNdvi = _generateMockNDVI(farmData);

      setState(() {
        _ndviData = mockNdvi;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'NDVI preview generated with mock data (backend offline)',
          ),
          backgroundColor: Color(0xFFFF9800),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating NDVI preview: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoadingNDVI = false;
      });
    }
  }

  String _formatNDVIValue(double value) {
    return value.toStringAsFixed(3);
  }

  String _formatContributingFactor(dynamic value) {
    if (value is double) {
      return value.toStringAsFixed(3);
    }
    return value?.toString() ?? '--';
  }

  List<Widget> _buildContributingFactorsList() {
    if (_ndviData == null || _ndviData!.contributingFactors.isEmpty) {
      return [];
    }

    final factors = _ndviData!.contributingFactors;
    return [
      Text(
        'Base NDVI: ${_formatContributingFactor(factors['base_ndvi'])}',
        style: const TextStyle(fontSize: 12),
      ),
      Text(
        'Seasonal Factor: ${_formatContributingFactor(factors['seasonal_factor'])}',
        style: const TextStyle(fontSize: 12),
      ),
      Text(
        'Irrigation: ${factors['irrigation_impact'] ?? '--'}',
        style: const TextStyle(fontSize: 12),
      ),
      Text(
        'Fertilizer: ${factors['fertilizer_impact'] ?? '--'}',
        style: const TextStyle(fontSize: 12),
      ),
      Text(
        'Tillage: ${factors['tillage_impact'] ?? '--'}',
        style: const TextStyle(fontSize: 12),
      ),
    ];
  }

  NDVI _generateMockNDVI(Map<String, dynamic> farmData) {
    // Generate realistic mock NDVI based on farm practices
    double baseNdvi = 0.5; // Base NDVI value

    // Adjust based on crop type
    final cropMultipliers = {
      'Rice': 0.65,
      'Wheat': 0.60,
      'Sugarcane': 0.75,
      'Cotton': 0.55,
      'Maize': 0.58,
      'Vegetables': 0.70,
    };
    baseNdvi = cropMultipliers[farmData['crop_type']] ?? 0.5;

    // Adjust based on irrigation
    final irrigationMultipliers = {
      'Solar': 1.1,
      'Electric': 1.05,
      'Diesel': 0.95,
    };
    baseNdvi *= irrigationMultipliers[farmData['irrigation_type']] ?? 1.0;

    // Adjust based on fertilizer
    final fertilizerMultipliers = {
      'Organic': 1.08,
      'Chemical': 1.02,
      'Mixed': 1.05,
      'None': 0.9,
    };
    baseNdvi *= fertilizerMultipliers[farmData['fertilizer_type']] ?? 1.0;

    // Adjust based on tilling
    final tillingMultipliers = {
      'No-Till': 1.1,
      'Reduced Till': 1.05,
      'Conventional': 0.95,
    };
    baseNdvi *= tillingMultipliers[farmData['tilling_method']] ?? 1.0;

    // Add some random variation
    final randomVariation =
        (DateTime.now().millisecondsSinceEpoch % 100) / 1000.0; // 0.0 to 0.1
    baseNdvi += randomVariation - 0.05; // ±0.05 variation

    // Ensure NDVI is within valid range
    baseNdvi = baseNdvi.clamp(0.2, 0.9);

    // Determine health status
    String healthStatus;
    if (baseNdvi < 0.4) {
      healthStatus = 'Poor';
    } else if (baseNdvi < 0.6) {
      healthStatus = 'Moderate';
    } else if (baseNdvi < 0.75) {
      healthStatus = 'Good';
    } else {
      healthStatus = 'Excellent';
    }

    return NDVI(
      ndvi: baseNdvi,
      healthStatus: healthStatus,
      contributingFactors: {
        'base_ndvi': baseNdvi,
        'seasonal_factor': 0.60,
        'irrigation_impact': farmData['irrigation_type'],
        'fertilizer_impact': farmData['fertilizer_type'],
        'tillage_impact': farmData['tilling_method'],
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _farmSizeController.dispose();
    _fertilizerQtyController.dispose();
    super.dispose();
  }
}
