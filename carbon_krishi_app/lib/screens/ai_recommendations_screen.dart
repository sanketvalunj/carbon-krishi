import 'package:flutter/material.dart';

class AIRecommendationsScreen extends StatelessWidget {
  final String farmerName;
  
  const AIRecommendationsScreen({Key? key, required this.farmerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology, color: Color(0xFF2E7D32), size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Personalized for $farmerName',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on your farm data',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            _buildRecommendationCard(
              context,
              icon: Icons.park,
              title: 'Plant More Trees',
              description: 'Plant 10 more trees to increase carbon sequestration',
              impact: '+8 credits/year',
              color: const Color(0xFF2E7D32),
            ),
            _buildRecommendationCard(
              context,
              icon: Icons.wb_sunny,
              title: 'Switch to Solar Irrigation',
              description: 'Reduce emissions by 30% with solar-powered pumps',
              impact: '+12 credits/year',
              color: const Color(0xFFFFB300),
            ),
            _buildRecommendationCard(
              context,
              icon: Icons.grass,
              title: 'Try No-Till Farming',
              description: 'Improve soil carbon storage and reduce erosion',
              impact: '+15 credits/year',
              color: const Color(0xFF00897B),
            ),
            _buildRecommendationCard(
              context,
              icon: Icons.compost,
              title: 'Use More Compost',
              description: 'Replace 50% of chemical fertilizers with compost',
              impact: '+10 credits/year',
              color: const Color(0xFF8D6E63),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String impact,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    impact,
                    style: const TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Learn more about $title')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                  ),
                  child: const Text('Learn More'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}