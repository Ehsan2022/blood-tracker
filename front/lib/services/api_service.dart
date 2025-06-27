import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/donation.dart';

// Inside ApiService class:

Future<List<Donation>> fetchDonationsByDonor(int donorId) async {
  var baseUrl;
  final res = await http.get(Uri.parse('$baseUrl/donations/donor/$donorId'));
  final data = json.decode(res.body) as List;
  return data.map((e) => Donation.fromJson(e)).toList();
}

Future<void> createDonation(Donation donation, dynamic baseUrl) async {
  await http.post(
    Uri.parse('$baseUrl/donations'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(donation.toJson()),
  );
}

Future<void> updateDonation(Donation donation, dynamic baseUrl) async {
  await http.put(
    Uri.parse('$baseUrl/donations/${donation.id}'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(donation.toJson()),
  );
}

Future<void> deleteDonation(int id, dynamic baseUrl) async {
  await http.delete(Uri.parse('$baseUrl/donations/$id'));
}
