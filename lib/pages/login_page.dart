import 'package:flutter/material.dart';
import 'package:spotify_polls/pages/votelists_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.title = "Login Page"});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: const TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const VotelistsPage()));
                },
                child: const Text('go to votelists page'))
          ],
        ),
      ),
    );
  }
}
