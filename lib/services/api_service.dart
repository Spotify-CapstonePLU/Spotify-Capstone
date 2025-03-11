import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = "http://localhost:3000";

  static Future<dynamic> getSpotifyAuthorization() async {
    final response = await http.get(Uri.parse('$baseUrl/auth'));
  }
}