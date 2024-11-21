import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotify_polls/voting_page.dart';

class VotelistsPage extends StatefulWidget {
  const VotelistsPage({super.key, this.title = "Votelists Page"});

  final String title;

  @override
  State<VotelistsPage> createState() => _VotelistsPageState();
}

class _VotelistsPageState extends State<VotelistsPage> {
  List<Widget> buttons = [];

  void addNewButton(String name) {
    setState(() {
      buttons.add(
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VotingPage()));
            },
            child: Text(name),
          ),
        ),
      );
    });
  }

  bool _isBlurred = false;

  void _toggleBlur() {
    setState(() {
      _isBlurred = !_isBlurred;
    });
  }

  void _showCreatePopup(BuildContext context) async {
    final myController = TextEditingController();

    inputField() {
      return TextField(
        controller: myController,
      );
    }

    displayInputFieldValueButton() {
      return FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          Navigator.of(context).pop(myController.text);
          myController.dispose();
        },
        child: const Text("Submit"),
      );
    }

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Create Popup", style: TextStyle(fontSize: 18)),
                inputField(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    displayInputFieldValueButton(),
                    ElevatedButton(
                      onPressed: () {
                        myController.dispose();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Close"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      addNewButton(result);
    }

    _toggleBlur();
  }

  void _showRegisterPopup(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Register popup", style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    log("Playlist 1 button pressed!");
                    Navigator.of(context).pop("Playlist 1");
                  },
                  child: const Text("Playlist 1"),
                ),
                ElevatedButton(
                  onPressed: () {
                    log("Playlist 2 button pressed!");
                    Navigator.of(context).pop("Playlist 2");
                  },
                  child: const Text("Playlist 2"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      addNewButton(result);
    }

    _toggleBlur();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size and FAB dimensions
    const double fabHeight = 56.0; // Default FAB height
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final double rightPadding = MediaQuery.of(context).viewPadding.right;

    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
              onTap: () {
                log("cancel new votelist");
                _toggleBlur();
              },
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      child: const BackButton()),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Main Page Content",
                          style: TextStyle(fontSize: 20),
                        ),
                        Column(
                          children: buttons,
                        )
                      ],
                    ),
                  ),
                  if (_isBlurred)
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.transparent,
                        )),
                  if (_isBlurred) ...[
                    Positioned(
                      bottom: fabHeight + bottomPadding + 32.0,
                      right: rightPadding + 16.0,
                      child: Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _showCreatePopup(context);
                                log("Create Votelist pressed");
                              },
                              child: const Text("Create Votelist")),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                _showRegisterPopup(context);
                                log("Register Votelist pressed");
                              },
                              child: const Text("Register Votelist")),
                        ],
                      ),
                    ),
                  ],
                ],
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleBlur,
        child: Text(
          _isBlurred ? "Close" : "Open Menu",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
