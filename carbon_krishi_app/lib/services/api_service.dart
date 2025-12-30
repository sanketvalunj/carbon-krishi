import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ndvi.dart';
import '../utils/constants.dart' as constants;

class ApiService {
  static String get baseUrl => constants.baseUrl;

  static Future<bool> registerFarmer({
    required String phone,
    required String name,
    required String village,
    required String farmSize,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': phone,
        'name': name,
        'village': village,
        'farm_size': double.parse(farmSize),
      }),
    );

    return response.statusCode == 200;
  }

  static Future<NDVI> getNDVI(String farmId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/satellite/ndvi/$farmId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return NDVI.fromJson({
        'ndvi': data['ndvi'],
        'health_status': data['health_status'],
        'contributing_factors': data['contributing_factors'],
      });
    } else {
      throw Exception('Failed to load NDVI data');
    }
  }
}
