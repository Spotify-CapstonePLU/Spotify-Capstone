import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

import '../models/poll.dart';

class Voting extends StatefulWidget {
  const Voting({super.key, required this.polls});
  final List<Poll> polls;

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
    _songCards = widget.polls
        .map((poll) {
          return SongCardData(
            songName: poll.song.title,
            artistNames: poll.song.artists.toString().substring(1, poll.song.artists.toString().length-1),
            trackArt: poll.song.imageUrl,
            votes: [poll.upvotes.toDouble(), poll.downvotes.toDouble()],
          );
        })
        .whereType<SongCardData>()
        .toList();
  }

  void _addSong() {
    setState(() {
      _songCards.insert(
          0,
          SongCardData(
            songName: "Song ${_songCards.length + 1}",
            artistNames: "Artist ${_songCards.length + 1}",
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
    final boxHeight = screenHeight * 0.85;

    const double aspectRatio = 2 / 3;

    final maxHeight = screenHeight;
    final maxWidth = maxHeight * aspectRatio;

    final containerWidth = maxWidth > screenWidth ? screenWidth : maxWidth;

    final dragWidth = (screenWidth - (containerWidth * 0.65)) / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHoveringYes ? 1.0 : 0.0,
              child: Container(
                width: dragWidth,
                height: boxHeight,
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
                width: dragWidth,
                height: boxHeight,
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
