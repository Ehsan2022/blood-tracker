import 'package:class_project/app_theme.dart';
import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../models/donation.dart';
import '../services/api_service.dart';
import 'donation_form.dart';
import 'donor_form.dart';

class DonorDetailScreen extends StatefulWidget {
  final Donor donor;

  const DonorDetailScreen({super.key, required this.donor});

  @override
  State<DonorDetailScreen> createState() => _DonorDetailScreenState();
}

class _DonorDetailScreenState extends State<DonorDetailScreen> {
  late Future<List<Donation>> _donationsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    setState(() => _isLoading = true);
    try {
      _donationsFuture = ApiService.fetchDonationsByDonor(widget.donor.id ?? 0);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDonation(int id) async {
    try {
      await ApiService.deleteDonation(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation deleted successfully')),
      );
      _loadDonations();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting donation: $e')),
      );
    }
  }

  Future<void> _deleteDonor(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this donor?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ApiService.deleteDonor(widget.donor.id!);
        if (!mounted) return;
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting donor: $e')),
        );
      }
    }
  }

  Future<void> _editDonor(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DonorFormScreen(donor: widget.donor),
      ),
    );
    
    if (result != null && mounted) {
      _loadDonations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final donor = widget.donor;
    return Scaffold(
      appBar: AppBar(
        title: Text(donor.name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade900,
                Colors.red.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editDonor(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deleteDonor(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ModernCard(
              child: Column(
                children: [
                  _buildInfoRow(Icons.person, donor.name),
                  _buildInfoRow(Icons.cake, '${donor.age} years'),
                  _buildInfoRow(Icons.transgender, donor.gender ?? 'Unknown'),
                  _buildInfoRow(Icons.bloodtype, donor.bloodGroup ?? 'Unknown'),
                  _buildInfoRow(Icons.phone, donor.phone ?? 'Not provided'),
                  _buildInfoRow(Icons.location_city, donor.city ?? 'Unknown'),
                  _buildInfoRow(Icons.calendar_today, 
                    donor.lastDonation?.toString() ?? 'Never donated'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Donation History', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Expanded(
              child: _buildDonationList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DonationFormScreen(donorId: donor.id ?? 0),
            ),
          );
          _loadDonations();
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.red.shade700),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: AppTextStyles.bodyLarge)),
        ],
      ),
    );
  }

  Widget _buildDonationList() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<List<Donation>>(
            future: _donationsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Failed to load donations', 
                        style: AppTextStyles.headlineMedium),
                    ],
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bloodtype_outlined, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('No donations yet', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 8),
                      const Text('Tap the + button to add a donation',
                        style: AppTextStyles.bodyMedium),
                    ],
                  ),
                );
              }
              return ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final donation = snapshot.data![index];
                  return ModernCard(
                    padding: const EdgeInsets.all(12),
                    child: ListTile(
                      leading: const Icon(Icons.bloodtype, 
                        color: Colors.red, size: 32),
                      title: Text(
                        donation.date ?? 'Unknown date',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (donation.hospital != null)
                            Text('At: ${donation.hospital}'),
                          if (donation.units != null)
                            Text('Units: ${donation.units}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteDonation(donation.id ?? 0),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DonationFormScreen(
                              donorId: widget.donor.id ?? 0,
                              donation: donation,
                            ),
                          ),
                        );
                        _loadDonations();
                      },
                    ),
                  );
                },
              );
            },
          );
  }
}