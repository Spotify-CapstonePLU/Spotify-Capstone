import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spotify_polls/pages/live_login_page.dart';
import '../assets/constants.dart' as constants;
import 'package:spotify_polls/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = "Home Page"});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center, // Distributes elements
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TitleSection(),
              SizedBox(height: 100,),
              ButtonSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              child: Text(
            constants.appName,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 25,),
          Flexible(
              child: Text(
            constants.appDescription,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ))
        ],
      ),
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                log("clicked Sign In");
                ApiService.getSpotifyAuthorization();
              },
              child: const Text(constants.signIn)),
          TextButton(
              onPressed: () {
                log("clicked Join Live");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LiveLoginPage()));
              },
              child: const Text(constants.joinLive))
        ],
      ),
    );
  }
}
