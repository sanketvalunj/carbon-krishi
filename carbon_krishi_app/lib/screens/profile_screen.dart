import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String farmerName;

  const ProfileScreen({super.key, required this.farmerName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Profile Header
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF2E7D32),
            child: Text(
              farmerName[0].toUpperCase(),
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            farmerName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text('+91 98765 43210', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          const Chip(
            label: Text('Verified Farmer ✓'),
            backgroundColor: Color(0xFFE8F5E9),
            labelStyle: TextStyle(color: Color(0xFF2E7D32)),
          ),
          const SizedBox(height: 32),

          // Farm Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Farm Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.landscape, 'Total Area', '5 acres'),
                  _buildInfoRow(
                    Icons.location_on,
                    'Village',
                    'Pimpri, Maharashtra',
                  ),
                  _buildInfoRow(Icons.grass, 'Primary Crop', 'Rice'),
                  _buildInfoRow(Icons.park, 'Trees Planted', '75 trees'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Settings List
          Card(
            child: Column(
              children: [
                _buildSettingTile(
                  context,
                  Icons.language,
                  'Language',
                  'English',
                  () {},
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  Icons.notifications,
                  'Notifications',
                  'Enabled',
                  () {},
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  Icons.help,
                  'Help & Support',
                  '',
                  () {},
                ),
                const Divider(height: 1),
                _buildSettingTile(
                  context,
                  Icons.info,
                  'About CarbonKrishi',
                  'v1.0.0 by NexAi',
                  () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF2E7D32)),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
