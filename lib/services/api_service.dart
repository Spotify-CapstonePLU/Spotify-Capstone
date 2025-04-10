import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:3000";

  static Future<dynamic> getSpotifyAuthorization(BuildContext context) async {
    const authUrl = '$baseUrl/auth';
    
    if (await canLaunchUrl(Uri.parse(authUrl))) {
      await launchUrl(
        Uri.parse(authUrl),
        mode: LaunchMode.inAppWebView,
        webOnlyWindowName: '_self',
      );
    } else {
      log("Could not launch login");
    }
  }
}
