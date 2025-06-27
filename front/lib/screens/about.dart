import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('About LifeBlood'),
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
              tag: 'app-logo',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.red.shade50,
                child: const Icon(Icons.bloodtype, size: 60, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'LifeBlood Donor App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 5),
            FutureBuilder<String>(
              future: _getAppVersion(),
              builder: (context, snapshot) {
                return Text(
                  snapshot.hasData ? 'Version ${snapshot.data}' : 'Version 1.0.0',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                );
              },
            ),
            const SizedBox(height: 30),
            _buildAboutSection(
              'About the App',
              'LifeBlood helps blood banks manage donors efficiently with:\n\n'
              '• Donor profiles management\n• Blood type tracking\n• Donation history\n• Analytics dashboard',
              Icons.bloodtype,
            ),
            const SizedBox(height: 20),
            _buildAboutSection(
              'Our Mission',
              'To connect blood donors with recipients quickly and efficiently, '
              'ensuring no one suffers due to lack of blood availability.',
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildAboutSection(
              'Contact Us',
              'For support or partnership inquiries:\n\n'
              'Email: support@lifeblood.app\n'
              'Phone: +1 (555) 123-4567\n'
              'Address: 123 Health St, Medical City',
              Icons.contact_mail,
            ),
            const SizedBox(height: 20),
            _buildAboutSection(
              'Acknowledgements',
              'We thank:\n\n'
              '• Our dedicated blood donors\n• Medical professionals\n• Open source contributors\n• The Flutter community',
              Icons.volunteer_activism,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(String title, String content, IconData icon) {
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

  Future<String> _getAppVersion() async {
    // In a real app, you would use package_info_plus
    await Future.delayed(const Duration(milliseconds: 300));
    return '1.2.0';
  }
}