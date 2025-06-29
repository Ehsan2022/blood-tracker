import 'package:class_project/models/donation.dart';

class Donor {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String? phone;
  final String? city;
  final DateTime? lastDonation;
   final int donationCount;
  final List<Donation>? donations;

  Donor( {
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    this.phone,
    this.city,
    this.lastDonation,
    this.donations,
    this.donationCount =0,
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
    return Donor(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      phone: json['phone'],
      city: json['city'],
      lastDonation: json['lastDonation'] != null 
          ? DateTime.parse(json['lastDonation']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phone': phone,
      'city': city,
      'lastDonation': lastDonation?.toIso8601String(),
    };
  }
}