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
            Text(
              'Version 1.0.0\nDeveloped by: Mohammad Ehsan Nicksarisht\n',
              style:  TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
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
              'Email: ehsan.nick16@gmail.com\n'
              'Phone: +93 790 234 314\n'
              'Address: Herat city, Herat, Afghanistan\n'              ,
              Icons.contact_mail,
            ),
            const SizedBox(height: 20),
            _buildAboutSection(
              'Acknowledgements',
              'We thank:\n\n'
              '• Our dedicated blood donors\n• Medical professionals\n• Open source contributors\n• Community partners\n',
              Icons.volunteer_activism,
            ),
            SizedBox(height: 130),
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

}