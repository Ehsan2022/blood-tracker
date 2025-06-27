import 'package:flutter/material.dart';
import '../models/donor.dart';
import '../services/api_service.dart';
// Make sure that the file '../services/api_service.dart' actually defines 'ApiService' class with static methods 'createDonor' and 'updateDonor'.

class DonorFormScreen extends StatefulWidget {
  final Donor? donor;
  DonorFormScreen({this.donor});

  @override
  _DonorFormScreenState createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name, gender, bloodGroup, phone, city, lastDonation;
  late int age;

  @override
  void initState() {
    super.initState();
    final donor = widget.donor;
    name = donor?.name ?? '';
    age = donor?.age ?? 18;
    gender = donor?.gender ?? 'Male';
    bloodGroup = donor?.bloodGroup ?? 'A+';
    phone = donor?.phone ?? '';
    city = donor?.city ?? '';
    lastDonation = donor?.lastDonation ?? '';
  }

  void save() async {
    if (_formKey.currentState!.validate()) {
      final donor = Donor(
        id: widget.donor?.id,
        name: name,
        age: age,
        gender: gender,
        bloodGroup: bloodGroup,
        phone: phone,
        city: city,
        lastDonation: lastDonation,
      );
      if (widget.donor == null) {
        await ApiService.createDonor(donor);
      } else {
        await ApiService.updateDonor(donor);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.donor == null ? 'Add Donor' : 'Edit Donor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(initialValue: name, decoration: InputDecoration(labelText: 'Name'), onChanged: (v) => name = v),
              TextFormField(initialValue: age.toString(), decoration: InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number, onChanged: (v) => age = int.parse(v)),
              TextFormField(initialValue: gender, decoration: InputDecoration(labelText: 'Gender'), onChanged: (v) => gender = v),
              TextFormField(initialValue: bloodGroup, decoration: InputDecoration(labelText: 'Blood Group'), onChanged: (v) => bloodGroup = v),
              TextFormField(initialValue: phone, decoration: InputDecoration(labelText: 'Phone'), onChanged: (v) => phone = v),
              TextFormField(initialValue: city, decoration: InputDecoration(labelText: 'City'), onChanged: (v) => city = v),
              TextFormField(initialValue: lastDonation, decoration: InputDecoration(labelText: 'Last Donation (yyyy-mm-dd)'), onChanged: (v) => lastDonation = v),
              SizedBox(height: 20),
              ElevatedButton(child: Text('Save'), onPressed: save),
            ],
          ),
        ),
      ),
    );
  }
}
