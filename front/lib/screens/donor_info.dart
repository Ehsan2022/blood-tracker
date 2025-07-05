import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DonorInfoScreen extends StatelessWidget {
  const DonorInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                child: Icon(
                  Icons.health_and_safety,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.donorInfo,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            _buildInfoCard(
              context,
              AppLocalizations.of(context)!.whoCanDonate,
              AppLocalizations.of(context)!.donationRequirements,
              Icons.medical_services,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
              AppLocalizations.of(context)!.preparationTips,
              AppLocalizations.of(context)!.preparationDetails,
              Icons.health_and_safety,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
              AppLocalizations.of(context)!.duringDonation,
              AppLocalizations.of(context)!.duringDonationDetails,
              Icons.access_time,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
              AppLocalizations.of(context)!.afterDonation,
              AppLocalizations.of(context)!.afterDonationDetails,
              Icons.local_hospital,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
              AppLocalizations.of(context)!.healthBenefits,
              AppLocalizations.of(context)!.healthBenefitsDetails,
              Icons.favorite,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
              AppLocalizations.of(context)!.mythsVsFacts,
              AppLocalizations.of(context)!.mythsDetails,
              Icons.help_outline,
            ),
            const SizedBox(height: 20),
            _buildInfoCard(
              context,
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

  Widget _buildInfoCard(
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