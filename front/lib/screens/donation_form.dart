import 'package:class_project/services/api_service.dart';
import 'package:flutter/material.dart';
import '../models/donation.dart';

class DonationFormScreen extends StatefulWidget {
  final int donorId;
  final Donation? donation;

  const DonationFormScreen({super.key, required this.donorId, this.donation});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String date, hospital, notes;
  late int units;

  @override
  void initState() {
    super.initState();
    final d = widget.donation;
    date = d?.date ?? '';
    hospital = d?.hospital ?? '';
    units = d?.units ?? 1;
    notes = d?.notes ?? '';
  }

  void save() async {
  if (_formKey.currentState!.validate()) {
    final donation = Donation(
      id: widget.donation?.id,
      donorId: widget.donorId,
      date: date,
      hospital: hospital,
      units: units,
      notes: notes,
    );
    if (widget.donation == null) {
      await ApiService.createDonation(donation);
    } else {
      await ApiService.updateDonation(donation);
    }
    Navigator.pop(context, true);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.donation == null ? 'Add Donation' : 'Edit Donation')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(initialValue: date, decoration: InputDecoration(labelText: 'Date (yyyy-mm-dd)'), onChanged: (v) => date = v),
              TextFormField(initialValue: hospital, decoration: InputDecoration(labelText: 'Hospital'), onChanged: (v) => hospital = v),
              TextFormField(initialValue: units.toString(), decoration: InputDecoration(labelText: 'Units'), keyboardType: TextInputType.number, onChanged: (v) => units = int.parse(v)),
              TextFormField(initialValue: notes, decoration: InputDecoration(labelText: 'Notes'), onChanged: (v) => notes = v),
              SizedBox(height: 20),
              ElevatedButton(onPressed: save, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
