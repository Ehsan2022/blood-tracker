
import 'package:life_blood_donor/models/donation.dart';

class Donor {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final String bloodGroup;
  final String? phone;
  final String? city;
  final int donorCount;
  final List<Donation>? donations;
  final DateTime? created_at;

  Donor( {
    this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodGroup,
    this.phone,
    this.city,
    this.donations,
    this.donorCount =0,
    this.created_at,
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
    };
  }
}