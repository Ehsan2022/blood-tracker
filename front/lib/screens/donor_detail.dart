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
    Future<List<Donation>>? _donationsFuture; // Nullable future

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  Future<void> _loadDonations() async {
  print('Loading donations for donor ID: ${widget.donor.id}');
  try {
    final donations = await ApiService.fetchDonationsByDonor(widget.donor.id ?? 0);
    print('Received donations: ${donations.length}');
    setState(() {
      _donationsFuture = Future.value(donations);
    });
  } catch (e) {
    print('Error loading donations: $e');
    setState(() {
      _donationsFuture = Future.error(e);
    });
  }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Donor deleted successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 
                (MediaQuery.of(context).padding.top + kToolbarHeight + 130),
        left: 16,
        right: 16,
      ),
      dismissDirection: DismissDirection.up,
      duration: Duration(seconds: 3),
    ),
  );
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
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 25),
            ),
          ],
        ),
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
                  backgroundColor: Colors.red.shade500,
                  child: Text(
                    donor.bloodGroup,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 30),
                      onPressed: _editDonor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                      onPressed: _deleteDonor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.person, donor.name),
            _buildInfoRow(Icons.cake, '${donor.age} years'),
            _buildInfoRow(Icons.transgender, donor.gender),
            _buildInfoRow(Icons.bloodtype, donor.bloodGroup),
            if (donor.phone != null) _buildInfoRow(Icons.phone, donor.phone!),
            if (donor.city != null) _buildInfoRow(Icons.location_city, donor.city!),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: GestureDetector(
                onTap:() async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DonationFormScreen(donorId: widget.donor.id ?? 0),
                        ),
                      );
                      await _loadDonations();
                    }, 
                child: Container(
                  width: MediaQuery.of(context).size.width -80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                     "Add Donation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
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
      // Add debug print
      print('Snapshot state: ${snapshot.connectionState}');
      print('Snapshot data: ${snapshot.data}');
      print('Snapshot error: ${snapshot.error}');

      if (snapshot.connectionState == ConnectionState.waiting) {
        return SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (snapshot.hasError) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: _loadDonations,
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final donations = snapshot.data ?? [];
      
      if (donations.isEmpty) {
        return SliverToBoxAdapter(
          child: Center(child: Text('No donations found for this donor.')),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildDonationItem(donations[index]),
          childCount: donations.length,
        ),
      );
    },
  );
}
 Widget _buildDonationItem(Donation donation) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: const Icon(Icons.bloodtype, color: Colors.red),
      title: Text(
        donation.date ?? 'Date not available',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (donation.hospital != null) 
            Text('Hospital: ${donation.hospital}'),
          if (donation.units != null)
            Text('Units: ${donation.units}'),
          if (donation.notes != null && donation.notes!.isNotEmpty)
            Text('Notes: ${donation.notes}'),
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
          Icon(icon, color: Colors.red.shade700, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}