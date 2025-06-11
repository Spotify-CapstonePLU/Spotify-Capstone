import 'package:flutter/material.dart';
import 'package:spotify_polls/controllers/voting_controller.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

import '../models/poll.dart';

class Voting extends StatefulWidget {
  const Voting({super.key, required this.polls, required this.votingController});
  final VotingController votingController;
  final List<Poll> polls;

  @override
  State<StatefulWidget> createState() => _VotingState();
}

class _VotingState extends State<Voting> {

  bool isHoveringYes = false;
  bool isHoveringNo = false;

  @override
  @override
  void initState() {
    super.initState();
  }

  void voteYes(String pollId) {
    widget.votingController.castVote("yes", pollId);
  }

  void voteNo(String pollId) {
    widget.votingController.castVote("no", pollId);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final boxHeight = screenHeight * 0.85;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: DragTarget<int>(
          builder: (context, candidateData, rejectedData) {
            return AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isHoveringYes ? 1.0 : 0.0,
              child: Container(
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
            // voteYes();
            print('Accepted: $data');
          },
          onLeave: (data) {
            setState(() {
              isHoveringYes = false;
            });
          },
        ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SongCardList(pollData: widget.polls)
        ),
        Expanded(
          flex: 3,
          child: DragTarget<int>(
            builder: (context, candidateData, rejectedData) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isHoveringNo ? 1.0 : 0.0,
                child: Container(
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
              // voteNo();
              print('Accepted: $data');
            },
            onLeave: (data) {
              setState(() {
                isHoveringNo = false;
              });
            },
          )
        ),
      ],
    );
  }
}
