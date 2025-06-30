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
          children: [
            Hero(
              tag: 'donor-info-icon',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.red.shade50,
                child: const Icon(Icons.health_and_safety, size: 60, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Donor Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              'Who Can Donate?',
              '• Age 18-65 years (varies by country)\n• Weight at least 50kg (110 lbs)\n• Healthy with no active infections\n• Hemoglobin levels >12.5g/dL for women, >13.0g/dL for men\n• Minimum 8 weeks between donations\n• No tattoos/piercings in last 4 months',
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Preparation Tips',
              '• Eat iron-rich foods (red meat, spinach) 2-3 days before\n• Drink extra 500ml water before donation\n• Avoid fatty foods 24 hours before\n• No smoking 2 hours before/after\n• Bring ID and list of medications',
              Icons.health_and_safety,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'During Donation',
              '• The process takes about 10 minutes\n• You\'ll donate approximately 450ml\n• Staff will monitor you throughout\n• Relax and breathe normally\n• Let staff know if you feel unwell',
              Icons.access_time,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'After Donation',
              '• Rest for 15 minutes before leaving\n• Drink extra fluids for 24-48 hours\n• Avoid alcohol for 8 hours\n• No heavy exercise for 24 hours\n• Eat iron-rich meals for 2 weeks\n• Keep bandage on for 4-6 hours',
              Icons.local_hospital,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Health Benefits',
              '• Free mini health check (blood pressure, hemoglobin)\n• Burns approximately 650 calories\n• Reduces risk of heart disease by 33%\n• Lowers risk of certain cancers\n• Stimulates new blood cell production\n• Psychological benefit of saving lives',
              Icons.favorite,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Myths vs Facts',
              '• Myth: Donating is painful\n  Fact: Only slight pinch during needle insertion\n\n• Myth: Donating weakens you\n  Fact: Body replaces blood within 24-48 hours\n\n• Myth: You can get infections\n  Fact: Sterile equipment is used once and discarded',
              Icons.help_outline,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              'Emergency Donation',
              'In urgent cases (mass casualties, rare blood types):\n\n• Contact your nearest blood bank immediately\n• Special arrangements can be made\n• Even if recently donated, you may still help\n• Bring any previous donor records',
              Icons.warning_amber,
            ),
            const SizedBox(height: 130), // bottom margin
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
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}