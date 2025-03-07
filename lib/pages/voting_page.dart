import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/songQue.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key, this.title = "Voting Page"});
  final String title;

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  List<Widget> buttons = [];
  int noCounter = 0;
  int yesCounter = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 50,
                ),
                Column(
                  children: buttons,
                ),
                Container(
                  padding: const EdgeInsets.all(200),
                  color: Colors.blue,
                  child: const Text("Song",)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No's : $noCounter"),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          noCounter += 1;
                        });
                      },
                      child: const Text("X")),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          yesCounter += 1;
                        });
                      },
                      child: const Text("Y")),
                    Text("Yes's : $yesCounter"),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Songque()));
                },
                child: const Text("QUE")
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //   },
              //   child: const Text("go back")
              // ),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Text("+"),
      ),
    );
  }
}
