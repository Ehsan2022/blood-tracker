import 'package:class_project/screens/donor_form.dart';
import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../models/donation.dart';
import '../services/api_service.dart';
import 'donation_form.dart';

class DonorDetailScreen extends StatefulWidget {
  final Donor donor;

  const DonorDetailScreen({super.key, required this.donor});

  @override
  State<DonorDetailScreen> createState() => _DonorDetailScreenState();
}

class _DonorDetailScreenState extends State<DonorDetailScreen> {
  late Future<List<Donation>> _donationsFuture;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
    setState(() {
      _donationsFuture = ApiService.fetchDonationsByDonor(widget.donor.id ?? 0);
    });
  }

  Future<void> _handleRefresh() async {
    await _loadDonations();
  }

  Future<void> _deleteDonation(int id) async {
    try {
      await ApiService.deleteDonation(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Donation deleted successfully')),
      );
      await _loadDonations();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteDonor() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Delete this donor permanently?'),
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
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _editDonor() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonorFormScreen(donor: widget.donor),
      ),
    );
    
    if (result != null && mounted) {
      await _loadDonations();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donor.name),
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: Colors.red.shade700,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildDonorCard(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 16),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Donation History',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            _buildDonationList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade700,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DonationFormScreen(donorId: widget.donor.id ?? 0),
            ),
          );
          await _loadDonations();
        },
      ),
    );
  }

  Widget _buildDonorCard() {
    final donor = widget.donor;
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.red.shade50,
                  child: Text(
                    donor.bloodGroup ?? '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: _editDonor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteDonor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, donor.name),
            _buildInfoRow(Icons.cake, '${donor.age} years'),
            _buildInfoRow(Icons.transgender, donor.gender ?? 'Unknown'),
            _buildInfoRow(Icons.bloodtype, donor.bloodGroup ?? 'Unknown'),
            if (donor.phone != null) _buildInfoRow(Icons.phone, donor.phone!),
            if (donor.city != null) _buildInfoRow(Icons.location_city, donor.city!),
            _buildInfoRow(
              Icons.calendar_today,
              donor.lastDonation != null 
                  ? 'Last donated: ${donor.lastDonation!.toLocal().toString().split(' ')[0]}'
                  : 'Never donated',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationList() {
    return FutureBuilder<List<Donation>>(
      future: _donationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load donations'),
                  TextButton(
                    onPressed: _loadDonations,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverToBoxAdapter(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bloodtype_outlined, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No donations yet'),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationFormScreen(donorId: widget.donor.id ?? 0),
                        ),
                      );
                      await _loadDonations();
                    },
                    child: const Text('Add First Donation'),
                  ),
                ],
              ),
            ),
          );
        }
        
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final donation = snapshot.data![index];
              return _buildDonationItem(donation);
            },
            childCount: snapshot.data!.length,
          ),
        );
      },
    );
  }

  Widget _buildDonationItem(Donation donation) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: const Icon(Icons.bloodtype, color: Colors.red),
        title: Text(
          donation.date ?? 'Unknown date',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (donation.hospital != null) Text('Hospital: ${donation.hospital}'),
            if (donation.units != null) Text('Units: ${donation.units}'),
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
              builder: (context) => DonationFormScreen(
                donorId: widget.donor.id ?? 0,
                donation: donation,
              ),
            ),
          );
          await _loadDonations();
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
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}