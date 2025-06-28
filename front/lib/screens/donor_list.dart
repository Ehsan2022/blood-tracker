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

  @override
  void initState() {
    super.initState();
    _loadDonors();
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

  void _filterDonors() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDonors = _allDonors.where((donor) {
        return donor.name.toLowerCase().contains(query) ||
            (donor.bloodGroup?.toLowerCase().contains(query) ?? false) ||
            (donor.city?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  Future<void> _handleRefresh() async {
    await _loadDonors();
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
        title: const Text('Donor List'),
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
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.9),
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                hintText: 'Search donors...',
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

  Widget _buildDonorList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisExtent: 180, // Set your custom height here
      ),
      itemCount: _filteredDonors.length,
      itemBuilder: (context, index) {
        final donor = _filteredDonors[index];
        return _buildDonorCard(donor);
      },
    );
  }

  Widget _buildDonorCard(Donor donor) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child:Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToDetail(donor),
          child: Row(
            children: [
              // Left Section (30% - Red)
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade100,
                      Colors.red.shade600,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child:  Text(
                        donor.bloodGroup ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                     ),
                      const SizedBox(height: 8),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.place, size: 20, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            donor.city ?? 'Unknown',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Right Section (70% - White)
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
                          const Icon(Icons.cake, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${donor.age} years',
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
                            const Icon(Icons.phone, size: 16, color: Colors.grey),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Add Donor', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}