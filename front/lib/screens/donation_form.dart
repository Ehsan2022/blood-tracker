import 'package:flutter/material.dart';
import 'package:life_blood_donor/services/api_service.dart';
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
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).cardColor,
            ),
            dialogBackgroundColor: Theme.of(context).cardColor,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
            ),
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
          SnackBar(content: Text('Please select a date')),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                color: Theme.of(context).cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _dateController,
                        readOnly: true,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Donation Date',
                          labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () => _selectDate(context),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Hospital',
                          labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.local_hospital,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Units',
                          labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.bloodtype,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Notes',
                          labelStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                          ),
                          prefixIcon: Icon(
                            Icons.note,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
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
                            backgroundColor: Theme.of(context).colorScheme.primary,
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