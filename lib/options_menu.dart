import 'package:flutter/material.dart';
import 'package:spotify_polls/pages/login_page.dart';

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({super.key});

  void _onMenuSelected(String value, BuildContext context) {
    // Handle menu selection
    switch (value) {
      case "Sign Out":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.settings),
      onSelected: (value) => _onMenuSelected(value, context),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "Sign Out",
          child: Row(
            children: [
              Icon(Icons.logout),
              SizedBox(width: 8,),
              Text("Sign Out"),
            ],
          )
        ),
      ],
    );
  }

}