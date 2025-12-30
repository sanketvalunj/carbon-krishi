import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_dashboard_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _farmSizeController = TextEditingController();
  
  String _selectedLanguage = 'English';
  String _selectedVillage = 'Select Village';
  bool _isLoading = false;

  final List<String> _villages = [
    'Select Village',
    'Pimpri',
    'Chinchwad',
    'Pune Rural',
    'Baramati',
    'Indapur',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Language Toggle
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChoiceChip(
              label: Text(_selectedLanguage),
              selected: true,
              onSelected: (selected) {
                setState(() {
                  _selectedLanguage = _selectedLanguage == 'English' ? 'हिंदी' : 'English';
                });
              },
              selectedColor: const Color(0xFF66BB6A),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Welcome Farmer! 🌱',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Register to start earning carbon credits',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 40),

                // Phone Number
                _buildInputField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter 10-digit mobile number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (value.length != 10) {
                      return 'Phone number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Name
                _buildInputField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your name',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Village Dropdown
                _buildDropdownField(
                  label: 'Village / Location',
                  icon: Icons.location_on,
                  value: _selectedVillage,
                  items: _villages,
                  onChanged: (value) {
                    setState(() {
                      _selectedVillage = value!;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Farm Size
                _buildInputField(
                  controller: _farmSizeController,
                  label: 'Farm Size (Acres)',
                  hint: 'Enter farm size',
                  icon: Icons.landscape,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter farm size';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Register Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegistration,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Register with OTP',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Terms & Conditions
                const Center(
                  child: Text(
                    'By registering, you agree to our\nTerms & Conditions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF2E7D32)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: const Color(0xFFF5F5F5),
          ),
        ),
      ],
    );
  }

  Future<void> _handleRegistration() async {
    if (_formKey.currentState!.validate() && _selectedVillage != 'Select Village') {
      setState(() {
        _isLoading = true;
      });

      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeDashboardScreen(
              farmerName: _nameController.text,
            ),
          ),
        );
      }
    } else if (_selectedVillage == 'Select Village') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a village')),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }
}