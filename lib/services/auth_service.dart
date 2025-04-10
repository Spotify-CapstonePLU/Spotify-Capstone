import 'package:universal_html/html.dart' as html;
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier{
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkInitialAuth() async {
    final uri = Uri.parse(html.window.location.href);

    if(uri.pathSegments.contains('auth-callback')) {
      await _handleAuthCallback(uri);
      html.window.history.pushState({}, '', '/');
    }
  }

  Future<void> _handleAuthCallback(Uri uri) async {
    final success = uri.queryParameters['success'] == 'true';
    _isAuthenticated = success;

    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}