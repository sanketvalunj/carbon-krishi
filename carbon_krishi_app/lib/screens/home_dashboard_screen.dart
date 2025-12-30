import 'package:flutter/material.dart';
import 'farm_data_entry_screen.dart';
import 'carbon_credits_screen.dart';
import 'photo_upload_screen.dart';
import 'ai_recommendations_screen.dart';
import 'profile_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  final String farmerName;
  
  const HomeDashboardScreen({Key? key, required this.farmerName}) : super(key: key);

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _selectedIndex = 0;
  
  // Sample data - will be replaced with backend
  final double carbonScore = 12.5;
  final int totalCredits = 125;
  final double estimatedValue = 9375.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.eco, color: Colors.white),
            const SizedBox(width: 8),
            Text('CarbonKrishi', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeTab() : _buildProfileTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: const Color(0xFF757575),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Credits',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Green Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Welcome, ${widget.farmerName}! 👋',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                // Carbon Score Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.park,
                        size: 48,
                        color: Color(0xFF2E7D32),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Your Carbon Score',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$carbonScore',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const Text(
                        'tonnes CO₂e',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Cards Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionCard(
                  icon: Icons.edit_note,
                  title: 'Add Farm Data',
                  color: const Color(0xFF2E7D32),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const FarmDataEntryScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  icon: Icons.monetization_on,
                  title: 'My Carbon Credits',
                  color: const Color(0xFFFFB300),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CarbonCreditsScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  icon: Icons.camera_alt,
                  title: 'Upload Photos',
                  color: const Color(0xFF00897B),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PhotoUploadScreen()),
                    );
                  },
                ),
                _buildActionCard(
                  icon: Icons.lightbulb,
                  title: 'AI Suggestions',
                  color: const Color(0xFFE91E63),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AIRecommendationsScreen(farmerName: widget.farmerName),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStatRow(Icons.stars, 'Total Credits Earned', '$totalCredits credits'),
                    const Divider(height: 24),
                    _buildStatRow(Icons.currency_rupee, 'Estimated Value', '₹${estimatedValue.toStringAsFixed(0)}'),
                    const Divider(height: 24),
                    _buildStatRow(Icons.trending_up, 'This Month', '+15 credits'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Recent Activities
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Activities ✅',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildActivityItem('20 trees planted', '2 days ago'),
                    _buildActivityItem('Switched to no-till farming', '1 week ago'),
                    _buildActivityItem('Solar irrigation installed', '2 weeks ago'),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return ProfileScreen(farmerName: widget.farmerName);
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF212121),
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}