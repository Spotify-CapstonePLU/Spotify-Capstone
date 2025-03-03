import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/pages/live_room_page.dart';

class LiveLoginPage extends StatefulWidget {
  const LiveLoginPage({super.key, this.title = "Live Room Login"});

  final String title;

  @override
  State<LiveLoginPage> createState() => _LiveLoginPageState();
}

class _LiveLoginPageState extends State<LiveLoginPage> {
  String password = "password";

  final myController = TextEditingController();
  bool isWrong = false;
  inputField() {
    return TextFormField(
      controller: myController,
      decoration: InputDecoration(
        errorText: isWrong ? "Wrong Password" : null,
        hintText: "Room Code",
      ),
    );
  }

  displayInputFieldValueSubmit() {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () {
        log("submit button pressed");
        log("input: ${myController.text}");
        if (myController.text == password) {
          log("correct password");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LiveRoomPage()));
        } else {
          log("wrong password");
          setState(() {
            isWrong = true;
          });
        }
        myController.clear();
      },
      child: const Text("Submit"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputField(),
            displayInputFieldValueSubmit(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('back button'))
          ],
        ),
      ),
    );
  }
}
