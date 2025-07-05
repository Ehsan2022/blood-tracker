import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonorInfoScreen extends StatelessWidget {
  const DonorInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.donorInfo),
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
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: const Icon(Icons.health_and_safety, size: 60, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.donorInfo,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              AppLocalizations.of(context)!.whoCanDonate,
              AppLocalizations.of(context)!.donationRequirements,
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              AppLocalizations.of(context)!.preparationTips,
              AppLocalizations.of(context)!.preparationDetails,
              Icons.health_and_safety,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              AppLocalizations.of(context)!.duringDonation,
              AppLocalizations.of(context)!.duringDonationDetails,
              Icons.access_time,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              AppLocalizations.of(context)!.afterDonation,
              AppLocalizations.of(context)!.afterDonationDetails,
              Icons.local_hospital,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              AppLocalizations.of(context)!.healthBenefits,
              AppLocalizations.of(context)!.healthBenefitsDetails,
              Icons.favorite,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              AppLocalizations.of(context)!.mythsVsFacts,
              AppLocalizations.of(context)!.mythsDetails,
              Icons.help_outline,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              AppLocalizations.of(context)!.emergencyDonation,
              AppLocalizations.of(context)!.emergencyDetails,
              Icons.warning_amber,
            ),
            const SizedBox(height: 120),
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