import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donor.dart';

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
}
