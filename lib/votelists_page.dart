import 'package:flutter/material.dart';

class VotelistsPage extends StatefulWidget {
  const VotelistsPage({super.key, this.title = "Votelists Page"});

  final String title;

  @override
  State<VotelistsPage> createState() => _VotelistsPageState();
}

class _VotelistsPageState extends State<VotelistsPage> {

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
                Navigator.pop(
                    context
                );
              },
              child: const Text("go back")
            )
          ],
        ),
      ),
    );
  }
}