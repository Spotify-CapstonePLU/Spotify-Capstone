import 'package:flutter/material.dart';

class Songque extends StatefulWidget {
  const Songque({super.key, this.title = "Song Que"});
  final String title;

  @override
  State<Songque> createState() => _SongqueState();
}

class _SongqueState extends State<Songque> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border : OutlineInputBorder(),
                  label: Text("Song Name"),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context
                    );
                  },
                  child: const Text("Return")
              ),
            ]
          )
        )
      );
    }
}
//
// class SongOptions{
//   String songName;
//   String artist;
//   SongOptions({this.songName, this.artist})
// }
