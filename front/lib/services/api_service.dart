import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donor.dart';
import '../models/donation.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Helper method for handling responses
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  // Donor CRUD Operations
  static Future<List<Donor>> fetchDonors() async {
    final response = await http.get(Uri.parse('$baseUrl/donors'));
    final data = _handleResponse(response) as List;
    return data.map((json) => Donor.fromJson(json)).toList();
  }

  static Future<Donor> createDonor(Donor donor) async {
    final response = await http.post(
      Uri.parse('$baseUrl/donors'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donor.toJson()),
    );
    return Donor.fromJson(_handleResponse(response));
  }

  static Future<Donor> updateDonor(Donor donor) async {
    final response = await http.put(
      Uri.parse('$baseUrl/donors/${donor.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donor.toJson()),
    );
    return Donor.fromJson(_handleResponse(response));
  }

  static Future<void> deleteDonor(int id) async {
      final response = await http.delete(Uri.parse('$baseUrl/donors/$id'));
  // Accept either 200 (with body) or 204 (no content)
  if (response.statusCode == 200 || response.statusCode == 204) {
    return; // Success - no need to parse body
  } else {
    // Try to get error message if response has body
    final error = response.body.isEmpty 
        ? 'Failed to delete donor' 
        : json.decode(response.body)['message'];
    throw Exception(error);
  }
}

//------------------------------------  donation CRUD Operations ---------------------------------------//
  static Future<List<Donation>> fetchDonations() async {
    final response = await http.get(Uri.parse('$baseUrl/donations'));
    final data = _handleResponse(response) as List;
    return data.map((json) => Donation.fromJson(json)).toList();
  }

static Future<Donation> createDonation(Donation donation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/donations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donation.toJson()),
    );
    return Donation.fromJson(_handleResponse(response));
  }
  static Future<List<Donation>> fetchDonationsByDonor(int donorId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations/donor/$donorId'),
        headers: {'Content-Type': 'application/json'},
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      final data = _handleResponse(response) as List;
      return data.map((json) => Donation.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching donations: $e');
      rethrow;
    }
  }

  

  static Future<Donation> updateDonation(Donation donation) async {
    final response = await http.put(
      Uri.parse('$baseUrl/donations/${donation.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(donation.toJson()),
    );
    return Donation.fromJson(_handleResponse(response));
  }

  static Future<void> deleteDonation(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/donations/$id'));
    _handleResponse(response);
  }
}