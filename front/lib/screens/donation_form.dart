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
  late String hospital, notes;
  late int units;
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final d = widget.donation;
    hospital = d?.hospital ?? '';
    units = d?.units ?? 1;
    notes = d?.notes ?? '';
    
    // Initialize date if editing existing donation
    if (d?.date != null) {
      selectedDate = DateTime.tryParse(d!.date!);
      _dateController.text = _formatDate(selectedDate!);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.red.shade700,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  void save() async {
    if (_formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date')),
        );
        return;
      }

      final donation = Donation(
        id: widget.donation?.id,
        donorId: widget.donorId,
        date: _formatDate(selectedDate!),
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
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.donation == null ? 'Add Donation' : 'Edit Donation'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Donation Date',
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.red.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.calendar_month, color: Colors.red.shade700),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: hospital,
                        decoration: InputDecoration(
                          labelText: 'Hospital',
                          prefixIcon: Icon(Icons.local_hospital, color: Colors.red.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (v) => hospital = v,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter hospital name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: units.toString(),
                        decoration: InputDecoration(
                          labelText: 'Units',
                          prefixIcon: Icon(Icons.bloodtype, color: Colors.red.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => units = int.parse(v),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter units';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: notes,
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          prefixIcon: Icon(Icons.note, color: Colors.red.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                        onChanged: (v) => notes = v,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                          ),
                          onPressed: save,
                          child: Text(
                            'SAVE DONATION',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
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
}