import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

class Voting extends StatefulWidget {
  const Voting({super.key, required this.initSongCards});

  final List<SongCardData> initSongCards;

  @override
  State<StatefulWidget> createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  late List<SongCardData> _songCards;

  bool acceptedX = false;
  bool acceptedY = false;

  @override
  @override
  void initState() {
    super.initState();
    _songCards = List.from(widget.initSongCards);
  }

  void _addSong() {
    setState(() {
      _songCards.insert(
          0,
          SongCardData(
            songName: "Song ${_songCards.length + 1}",
            artistName: "Artist ${_songCards.length + 1}",
            trackArt: "assets/trackArtPlaceholder.png",
            votes: [0, 0], // Placeholder art
          ));
    });
  }

  void voteYes() {
    _songCards[_songCards.length - 1].votes[0] += 1;
  }

  void voteNo() {
    _songCards[_songCards.length - 1].votes[1] += 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 200,
              height: 200,
              color: candidateData.isNotEmpty ? const Color(0xff2036e1) : const Color(0xff6e43ec),
              child: Center(
                child: acceptedY ? const Icon(Icons.check, color: Colors.white, size: 75)
                : Text(
                  candidateData.isNotEmpty
                      ? 'Hovering: ${candidateData.first}' // Access the first item in the list
                      : 'Drag an item here!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          onWillAcceptWithDetails: (data) {
            // print('Will accept: $data');
            return true; // Indicate whether to accept the draggable item
          },
          onAcceptWithDetails: (data) {
            setState(() {
              acceptedY = true;
            });
            voteYes();
            // print('Accepted: $data');
          },
        ),
        SongCardList(songCards: _songCards, onAdd: _addSong),
        DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 200,
              height: 200,
              color: candidateData.isNotEmpty ? const Color(0xff7e0202) : const Color(0xffbf1212),
              child: Center(
                child: acceptedX ? const Icon(Icons.close, color: Colors.white, size: 75)
                : Text(
                  candidateData.isNotEmpty
                      ? 'Hovering: ${candidateData.first}' // Access the first item in the list
                      : 'Drag an item here!',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
          onWillAcceptWithDetails: (data) {
            // print('Will accept: $data');
            return true; // Indicate whether to accept the draggable item
          },
          onAcceptWithDetails: (data) {
            setState(() {
              acceptedX = true;
            });
            voteNo();
            // print('Accepted: $data');
          },
        ),
      ],
    );
  }
}
