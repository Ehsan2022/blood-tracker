import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donor.dart';
  import '../models/donation.dart';

class ApiService {
  static const baseUrl = 'http://10.0.2.2:8080/api';

 static Future<List<Donor>> fetchDonors() async {
  final res = await http.get(Uri.parse('$baseUrl/donors'));
  final data = json.decode(res.body) as List;
  return data.map((e) => Donor.fromJson(e)).toList();
  }



  static Future<void> createDonor(Donor donor) async {
    await http.post(Uri.parse('$baseUrl/donors'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donor.toJson()),
    );
  }

  static Future<void> deleteDonor(int id) async {
    await http.delete(Uri.parse('$baseUrl/donors/$id'));
  }

  static Future<void> updateDonor(Donor donor) async {
    await http.put(Uri.parse('$baseUrl/donors/${donor.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donor.toJson()),
    );
  }



// Fetch all donations for a donor
static Future<List<Donation>> fetchDonationsByDonor(int donorId) async {
  final res = await http.get(Uri.parse('$baseUrl/donations/donor/$donorId'));
  final data = json.decode(res.body) as List;
  return data.map((e) => Donation.fromJson(e)).toList();
}

// Create a new donation
static Future<void> createDonation(Donation donation) async {
  await http.post(
    Uri.parse('$baseUrl/donations'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(donation.toJson()),
  );
}

// Update an existing donation
static Future<void> updateDonation(Donation donation) async {
  await http.put(
    Uri.parse('$baseUrl/donations/${donation.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(donation.toJson()),
  );
}

// Delete a donation
static Future<void> deleteDonation(int id) async {
  await http.delete(Uri.parse('$baseUrl/donations/$id'));
}

}
