import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../models/donation.dart';
import '../services/api_service.dart';
import 'donation_form.dart';

class DonorDetailScreen extends StatefulWidget {
  final Donor donor;

  const DonorDetailScreen({required this.donor});

  @override
  State<DonorDetailScreen> createState() => _DonorDetailScreenState();
}

class _DonorDetailScreenState extends State<DonorDetailScreen> {
  late Future<List<Donation>> donations;

  @override
  void initState() {
    super.initState();
    _loadDonations();
  }

  void _loadDonations() {
    donations = ApiService.fetchDonors() as Future<List<Donation>>;
  }

  void _refresh() {
    setState(() => _loadDonations());
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.donor;
    return Scaffold(
      appBar: AppBar(title: Text('Donor: ${d.name}')),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                title: Text('${d.name}, ${d.age} (${d.gender})'),
                subtitle: Text('Blood: ${d.bloodGroup}\nPhone: ${d.phone}\nCity: ${d.city}\nLast Donation: ${d.lastDonation}'),
              ),
            ),
            SizedBox(height: 10),
            Text('Donation History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: FutureBuilder<List<Donation>>(
                future: donations,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  final items = snapshot.data!;
                  return ListView(
                    children: items.map((d) {
                      return Card(
                        child: ListTile(
                          title: Text('${d.date} - ${d.hospital}'),
                          subtitle: Text('${d.units} units\n${d.notes}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              await ApiService.deleteDonor(d.id!);
                              _refresh();
                            },
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DonationFormScreen(donorId: widget.donor.id!, donation: d),
                              ),
                            );
                            _refresh();
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DonationFormScreen(donorId: widget.donor.id!),
            ),
          );
          _refresh();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
