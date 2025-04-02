import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

class Voting extends StatefulWidget {
  const Voting({super.key,
  required this.initSongCards});

  final List<SongCardData> initSongCards;

  @override
  State<StatefulWidget> createState() => _VotingState();
}

class _VotingState extends State<Voting> {
  late List<SongCardData> _songCards;

  @override @override
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
            trackArt: Image.network(
                'assets/trackArtPlaceholder.png'),
            votes: [0, 0],// Placeholder art
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
              color: candidateData.isNotEmpty ? Colors.green : Colors.red,
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
            // print('Will accept: $data');
            return true; // Indicate whether to accept the draggable item
          },
          onAcceptWithDetails: (data) {
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
              color: candidateData.isNotEmpty ? Colors.green : Colors.red,
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
            // print('Will accept: $data');
            return true; // Indicate whether to accept the draggable item
          },
          onAcceptWithDetails: (data) {
            voteNo();
            // print('Accepted: $data');
          },
        ),
      ],
    );
  }
}