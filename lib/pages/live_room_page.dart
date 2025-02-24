import 'package:flutter/material.dart';
import 'package:spotify_polls/control_bar.dart';
import 'package:spotify_polls/custom_app_bar.dart';
import 'package:spotify_polls/song_cards.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key, this.title = "Live Room"});

  final String title;

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  final List<SongCardData> _songCards = [];

  void _addSong() {
    setState(() {
      _songCards.insert(
          0,
          SongCardData(
            songName: "Song ${_songCards.length + 1}",
            artistName: "Artist ${_songCards.length + 1}",
            trackArt: Image.network('assets/trackArtPlaceholder.png'),
            votes: [0, 0], // Placeholder art
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.sizeOf(context).shortestSide;

    void voteYes() {
      _songCards[_songCards.length - 1].votes[0] += 1;
    }

    void voteNo() {
      _songCards[_songCards.length - 1].votes[1] += 1;
    }

    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DragTarget<int>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 200,
                          height: 200,
                          color:
                              candidateData.isNotEmpty ? Colors.green : Colors.red,
                          child: Center(
                            child: Text(
                              candidateData.isNotEmpty
                                  ? 'Hovering: ${candidateData.first}' // Access the first item in the list
                                  : 'Drag an item here!',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      onWillAcceptWithDetails: (data) {
                        print('Will accept: $data');
                        return true; // Indicate whether to accept the draggable item
                      },
                      onAcceptWithDetails: (data) {
                        voteYes();
                        print('Accepted: $data');
                      },
                    ),
                    SongCardList(songCards: _songCards, onAdd: _addSong),
                    DragTarget<int>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          width: 200,
                          height: 200,
                          color:
                              candidateData.isNotEmpty ? Colors.green : Colors.red,
                          child: Center(
                            child: Text(
                              candidateData.isNotEmpty
                                  ? 'Hovering: ${candidateData.first}' // Access the first item in the list
                                  : 'Drag an item here!',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      onWillAcceptWithDetails: (data) {
                        print('Will accept: $data');
                        return true; // Indicate whether to accept the draggable item
                      },
                      onAcceptWithDetails: (data) {
                        voteNo();
                        print('Accepted: $data');
                      },
                    ),
                  ],
                ),
                ControlBar(size: shortestSide)
              ],
            ),
      ],
    ));
  }
}
