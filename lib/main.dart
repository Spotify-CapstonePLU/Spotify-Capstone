import 'package:flutter/material.dart';
import 'package:spotify_polls/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:spotify_polls/pages/votelists_page.dart';
import 'package:spotify_polls/services/auth_service.dart';
import 'package:spotify_polls/services/snackbar_service.dart';
import '../styles/themes.dart' as theme;

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: theme.defaultTheme,
        home: Consumer<AuthService>(
          builder: (context, auth, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              auth.checkInitialAuth();
            });

            return auth.isAuthenticated ? const VotelistsPage() : const HomePage();
          },
        ),
        scaffoldMessengerKey: SnackbarService.messengerKey,
    );
  }
}
