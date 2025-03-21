import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:3000";

  static Future<dynamic> getSpotifyAuthorization() async {
    const authUrl = 'http://127.0.0.1:3000/auth';
    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(Uri.parse(authUrl));
    } else {
      log("Could not launch login");
    }
  }
}
