import 'package:class_project/models/donation.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../models/donor.dart';
import '../services/api_service.dart';
import 'donor_detail.dart';
import 'donor_form.dart';

class DonorListScreen extends StatefulWidget {
  const DonorListScreen({super.key});

  @override
  State<DonorListScreen> createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  late Future<List<Donor>> _donorsFuture;
  List<Donor> _allDonors = [];
  List<Donor> _filteredDonors = [];
  final TextEditingController _searchController = TextEditingController();
  
  // donation count
  List<Donation> _allDonations = [];

  @override
  void initState() {
    super.initState();
    _loadDonors();
    _loadDonations(); // Added for donation count
    _searchController.addListener(_filterDonors);
  }

  Future<void> _loadDonors() async {
    setState(() {
      _donorsFuture = ApiService.fetchDonors().then((donors) {
        _allDonors = donors;
        _filteredDonors = donors;
        return donors;
      });
    });
  }

  // donation count
  Future<void> _loadDonations() async {
    try {
      final donations = await ApiService.fetchDonations();
      setState(() {
        _allDonations = donations;
      });
    } catch (e) {
      debugPrint('Error loading donations: $e');
    }
  }

  void _filterDonors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDonors = _allDonors.where((donor) {
        return donor.name.toLowerCase().contains(query) ||
            (donor.bloodGroup.toLowerCase().contains(query)) ||
            (donor.phone!.contains(query)) ||
            (donor.city?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  Map<String, int> _getBloodGroupCounts() {
    final counts = <String, int>{};
    for (var donor in _allDonors) {
      final bg = donor.bloodGroup;
      counts[bg] = (counts[bg] ?? 0) + 1;
    }
    return counts;
  }

  Future<void> _handleRefresh() async {
    await _loadDonors();
    await _loadDonations(); // Added for donation count
  }

  Future<void> _navigateToDetail(Donor donor) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonorDetailScreen(donor: donor),
      ),
    );
    
    if (result == true) {
      await _loadDonors();
    }
  }

  Future<void> _deleteDonor(int id) async {
    try {
      await ApiService.deleteDonor(id);
      if (!mounted) return;
      await _loadDonors();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Donor deleted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildStatItem(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.red.shade700),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    if (_allDonors.isEmpty) return const SizedBox();

    final bloodGroups = _getBloodGroupCounts();
    final totalDonors = _allDonors.length;
    final totalDonations = _allDonations.length; 

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              _buildStatItem(Icons.people, 'Total Donors', totalDonors),
              _buildStatItem(Icons.bloodtype, 'Total Donations', totalDonations),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.spaceBetween,
                spacing: 20,
                runSpacing: 10,
                children: bloodGroups.entries.map((entry) {
                return Chip(
                  shadowColor: Colors.black,
                  elevation: 5,
                  label: Text('${entry.key} : ${entry.value}'),
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                  color: Colors.red.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                  ),
                );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorList() {
    return Column(
      children: [
        _buildStatsCard(),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 180,
            ),
            itemCount: _filteredDonors.length,
            itemBuilder: (context, index) {
              final donor = _filteredDonors[index];
              return _buildDonorCard(donor);
            },
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }

  Widget _buildDonorCard(Donor donor) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToDetail(donor),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 255, 237, 235),
                    Colors.red.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.red,
                  child: Text(
                    donor.bloodGroup,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      donor.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.cake, size: 16, color: Colors.red.shade700),
                        const SizedBox(width: 4),
                        Text(
                          '${donor.age} years',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.place, size: 16, color: Colors.red.shade700),
                        const SizedBox(width: 4),
                        Text(
                          donor.city ?? 'Unknown City',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                    if (donor.phone != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.red.shade700),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              donor.phone!,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 16,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
          const SizedBox(height: 16),
          Text(
            'Failed to load donors',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadDonors,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? 'No donors found'
                : 'No matching donors',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'Add your first donor'
                : 'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DonorFormScreen(),
                ),
              );
              await _loadDonors();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Donor', style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade900, Colors.red.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                hintText: 'Search donor\'s name, phone, city...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
        ),
      ),
      body: LiquidPullToRefresh(
        onRefresh: _handleRefresh,
        color: Colors.red.shade700,
        height: 150,
        backgroundColor: Colors.white,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        child: FutureBuilder<List<Donor>>(
          future: _donorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _buildErrorState();
            }
            if (!snapshot.hasData || _filteredDonors.isEmpty) {
              return _buildEmptyState();
            }
            return _buildDonorList();
          },
        ),
      ),
    );
  }
}