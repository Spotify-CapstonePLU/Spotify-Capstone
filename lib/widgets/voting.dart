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

  bool isHoveringYes = false;
  bool isHoveringNo = false;


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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    const minScreenHeight = 675.0;
    const minScreenWidth = 750.0;
    final boxSizeW = screenWidth * 0.3;
    final boxSizeH = screenHeight * 0.7;

    if (screenWidth < minScreenWidth) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '⚠️ Screen is too narrow for voting.\nPlease expand your window or use a larger device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    if (screenHeight < minScreenHeight) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            '⚠️ Screen is too small for voting.\nPlease expand your window or use a larger device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHoveringYes ? 1.0 : 0.0,
              child: Container(
                width: boxSizeW,
                height: boxSizeH,
                decoration: BoxDecoration(
                  color: const Color(0xff2036e1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Colors.white, size: 150),
                ),
              ),
            );
          },
          onWillAcceptWithDetails: (data) {
            // print('Will accept: $data');
            setState(() {
              isHoveringYes = true;
            });
            return true; // Indicate whether to accept the draggable item
          },
          onAcceptWithDetails: (data) {
            setState(() {
              isHoveringYes = false;
            });
            voteYes();
            // print('Accepted: $data');
          },
          onLeave: (data) {
            setState(() {
              isHoveringYes = false;
            });
          },
        ),
        SongCardList(songCards: _songCards, onAdd: _addSong),
        DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHoveringNo ? 1.0 : 0.0,
              child: Container(
                width: boxSizeW,
                height: boxSizeH,
                decoration: BoxDecoration(
                  color: const Color(0xffbf1212), // Red background
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(
                  child: Icon(Icons.close, color: Colors.white, size: 150),
                ),
              ),
            );
          },
          onWillAcceptWithDetails: (data) {
            setState(() {
              isHoveringNo = true;
            });
            return true;
          },
          onAcceptWithDetails: (data) {
            setState(() {
              isHoveringNo = false;
            });
            voteNo();
          },
          onLeave: (data) {
            setState(() {
              isHoveringNo = false;
            });
          },
        ),
      ],
    );
  }
}
