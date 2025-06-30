import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about),
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
            const SizedBox(height: 30),
            _buildAboutCard(
              AppLocalizations.of(context)!.aboutApp,
              AppLocalizations.of(context)!.appDescription,
              Icons.bloodtype,
            ),
            const SizedBox(height: 20),
            _buildAboutCard(
              AppLocalizations.of(context)!.ourMission,
              AppLocalizations.of(context)!.missionDescription,
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildAboutCard(
              AppLocalizations.of(context)!.contactUs,
              AppLocalizations.of(context)!.contactDetails,
              Icons.contact_mail,
            ),
            const SizedBox(height: 20),
            _buildAboutCard(
              AppLocalizations.of(context)!.acknowledgements,
              AppLocalizations.of(context)!.acknowledgementsText,
              Icons.volunteer_activism,
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard(String title, String content, IconData icon) {
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