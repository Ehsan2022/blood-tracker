import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Icon(
                  Icons.bloodtype,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'LifeBlood Donor App',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildAboutCard(
              context,
              AppLocalizations.of(context)!.aboutApp,
              AppLocalizations.of(context)!.appDescription,
              Icons.bloodtype,
            ),
            const SizedBox(height: 20),
            _buildAboutCard(
              context,
              AppLocalizations.of(context)!.ourMission,
              AppLocalizations.of(context)!.missionDescription,
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildAboutCard(
              context,
              AppLocalizations.of(context)!.contactUs,
              AppLocalizations.of(context)!.contactDetails,
              Icons.contact_mail,
            ),
            const SizedBox(height: 20),
            _buildAboutCard(
              context,
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

  Widget _buildAboutCard(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}