import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../services/api_service.dart';
import 'donor_form.dart';
import 'donor_detail.dart';

class DonorListScreen extends StatefulWidget {
  @override
  _DonorListScreenState createState() => _DonorListScreenState();
}

class _DonorListScreenState extends State<DonorListScreen> {
  late Future<List<Donor>> donors;

 @override
void initState() {
  super.initState();
  donors = ApiService.fetchDonors(); // No arguments required
}

void refresh() {
  setState(() {
    donors = ApiService.fetchDonors(); // No arguments required
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donors')),
      body: FutureBuilder<List<Donor>>(
        future: donors,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!
                .map((donor) => Card(
                      child: ListTile(
                        title: Text(donor.name),
                        subtitle: Text('${donor.bloodGroup} - ${donor.city}'),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DonorDetailScreen(donor: donor)),
                          );
                          refresh();
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await ApiService.deleteDonor(donor.id!);
                            refresh();
                          },
                        ),
                      ),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DonorFormScreen()),
          );
          refresh();
        },
      ),
    );
  }
}
