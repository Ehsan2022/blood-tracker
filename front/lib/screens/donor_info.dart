import 'package:flutter/material.dart';

class DonorInfoScreen extends StatelessWidget {
  const DonorInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Donor Information'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade900, Colors.red.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(
              'Who Can Donate?',
              '• Age 18-65 years\n• Weight at least 50kg\n• Healthy with no infections\n• Hemoglobin levels >12.5g/dL',
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Preparation Tips',
              '• Eat iron-rich foods before donating\n• Drink extra fluids\n• Avoid alcohol 24 hours before\n• Get a good night\'s sleep',
              Icons.health_and_safety,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'After Donation',
              '• Drink plenty of fluids\n• Avoid heavy lifting\n• Keep bandage for 4-6 hours\n• Eat iron-rich meals',
              Icons.local_hospital,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Benefits',
              '• Free health checkup\n• Burns 650 calories per donation\n• Reduces risk of heart disease\n• Saves up to 3 lives!',
              Icons.favorite,
            ),
            SizedBox(height: 130),
          ],
        
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.red.shade700, size: 28),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}