import 'package:flutter/material.dart';

class FarmDataEntryScreen extends StatefulWidget {
  const FarmDataEntryScreen({Key? key}) : super(key: key);

  @override
  State<FarmDataEntryScreen> createState() => _FarmDataEntryScreenState();
}

class _FarmDataEntryScreenState extends State<FarmDataEntryScreen> with SingleTickerProviderStateMixin {
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
    _tabController = TabController(length: 3, vsync: this);
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
            items: ['Rice', 'Wheat', 'Sugarcane', 'Cotton', 'Maize', 'Vegetables'],
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
                const SnackBar(content: Text('Location detected: Pimpri, Maharashtra')),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
            subtitle: Text(_useCompost ? 'Currently using compost' : 'Not using compost'),
            activeColor: const Color(0xFF2E7D32),
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
      value: value,
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

  Widget _buildRadioTiles(List<String> options, String selected, Function(String?) onChanged) {
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
        'farmSize': _farmSizeController.text.isNotEmpty ? double.tryParse(_farmSizeController.text) ?? 0.0 : 0.0,
        'cropType': _selectedCrop,
        'season': _selectedSeason,
        'fertilizerType': _selectedFertilizer,
        'fertilizerQty': _fertilizerQtyController.text.isNotEmpty ? double.tryParse(_fertilizerQtyController.text) ?? 0.0 : 0.0,
        'tilling': _selectedTilling,
        'irrigation': _selectedIrrigation,
        'treesPlanted': _treesPlanted,
        'useCompost': _useCompost,
      };

      Navigator.pop(context, data);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _farmSizeController.dispose();
    _fertilizerQtyController.dispose();
    super.dispose();
  }
}