import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donor.dart';
import '../models/donation.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Donor CRUD Operations
  static Future<List<Donor>> fetchDonors() async {
    final response = await http.get(Uri.parse('$baseUrl/donors'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Donor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load donors');
    }
  }

  static Future<Donor> createDonor(Donor donor) async {
    final response = await http.post(
      Uri.parse('$baseUrl/donors'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donor.toJson()),
    );
    if (response.statusCode == 201) {
      return Donor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create donor');
    }
  }

  static Future<Donor> updateDonor(Donor donor) async {
    final response = await http.put(
      Uri.parse('$baseUrl/donors/${donor.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donor.toJson()),
    );
    if (response.statusCode == 200) {
      return Donor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update donor');
    }
  }

  static Future<void> deleteDonor(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/donors/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete donor');
    }
  }

  // Donation CRUD Operations
  static Future<List<Donation>> fetchDonationsByDonor(int donorId) async {
    final response = await http.get(Uri.parse('$baseUrl/donations?donorId=$donorId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Donation.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load donations');
    }
  }

  static Future<void> deleteDonation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/donations/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete donation');
    }
  }



// Fetch all donations for a donor (alternative endpoint)
static Future<List<Donation>> fetchDonationsByDonorAlt(int donorId) async {
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

// Delete a donation (alternative)
static Future<void> deleteDonationAlt(int id) async {
  await http.delete(Uri.parse('$baseUrl/donations/$id'));
}

}
