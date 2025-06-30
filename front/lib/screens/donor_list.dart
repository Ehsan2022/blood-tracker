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
            (donor.bloodGroup.toLowerCase().contains(query)) ||
            (donor.phone!.contains(query)) ||
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

  Widget _buildDonorList() {
    return Column(
      children: [
        Expanded( 
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisExtent: 160,
            ),
            itemCount: _filteredDonors.length,
            padding: const EdgeInsets.only(bottom: 150),
            itemBuilder: (context, index) {
              final donor = _filteredDonors[index];
              return _buildDonorCard(donor);
            },
          ),
        ),
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