import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  Widget _buildDonorCard(Donor donor) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Theme.of(context).cardColor,
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
                    Colors.red[900]!.withOpacity(0.2),
                    Colors.red[700]!.withOpacity(0.4),
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
                  backgroundColor: Colors.red[700],
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
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      donor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.cake, size: 16, color: Colors.red[400]),
                        const SizedBox(width: 4),
                        Text(
                          '${donor.age} ${AppLocalizations.of(context)!.years}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.place, size: 16, color: Colors.red[400]),
                        const SizedBox(width: 4),
                        Text(
                          donor.city ?? 'Unknown',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    if (donor.phone != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 16, color: Colors.red[400]),
                          const SizedBox(width: 4),
                          Text(
                            donor.phone!,
                            style: const TextStyle(color: Colors.white70),
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
          Icon(Icons.error_outline, size: 48, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.failedToLoadDonors,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _loadDonors,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
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
            color: Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? AppLocalizations.of(context)!.noDonorsFound
                : AppLocalizations.of(context)!.noMatchingDonors,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? AppLocalizations.of(context)!.addFirstDonor
                : AppLocalizations.of(context)!.tryDifferentSearch,
            style: const TextStyle(color: Colors.white70),
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
              backgroundColor: Colors.red[700],
              padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 22),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add Donor',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.donors,
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[900]!, Colors.red[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                prefixIcon: const Icon(Icons.search, color: Colors.red),
                hintText: AppLocalizations.of(context)!.searchHint,
                hintStyle: const TextStyle(color: Colors.white54),
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
        color: Colors.red[700],
        height: 150,
        backgroundColor: Colors.grey[800],
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        child: FutureBuilder<List<Donor>>(
          future: _donorsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            }
            if (snapshot.hasError) {
              return _buildErrorState();
            }
            if (!snapshot.hasData || _filteredDonors.isEmpty) {
              return _buildEmptyState();
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 160,
              ),
              itemCount: _filteredDonors.length,
              padding: const EdgeInsets.only(bottom: 150),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: _buildDonorCard(_filteredDonors[index]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}