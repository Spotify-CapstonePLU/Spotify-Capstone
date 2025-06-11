import 'package:flutter/material.dart';
import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/models/poll.dart';
import 'package:spotify_polls/models/song.dart';
import 'package:spotify_polls/widgets/ring_chart.dart';

class SongCardList extends StatefulWidget {
  const SongCardList({
    super.key,
    required this.pollData,
  });

  final List<Poll> pollData;

  @override
  State<StatefulWidget> createState() => _SongCardListState();
}

class _SongCardListState extends State<SongCardList> {
  final int displayListMax = 5;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    const double aspectRatio = 2 / 3;

    final maxHeight = screenHeight;
    final maxWidth = maxHeight * aspectRatio;

    final containerWidth = maxWidth > screenWidth ? screenWidth : maxWidth;
    final containerHeight = containerWidth / aspectRatio;

    final double overlapOffset = containerHeight * 0.05;

    List<Poll> dateSortedPollData = List<Poll>.from(widget.pollData);
    dateSortedPollData.sort((a,b) => a.endTime.compareTo(b.endTime));

    List<SongCard> songCards = dateSortedPollData.map((p) => SongCard(cardData: p)).toList();
    songCards = songCards.reversed.toList();

    final start = songCards.length > displayListMax ? songCards.length - displayListMax : 0;
    final displayCards = songCards.skip(start).take(displayListMax).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: containerWidth * 0.6,
          height: containerHeight * 0.6,
          child: Stack(
            children: [
              for (int i = 0; i < displayCards.length; i++)
                Positioned(
                    bottom:
                      (displayCards.length-i) * overlapOffset - ((displayCards.length-i) * (displayCards.length-i) * containerHeight * 0.005),
                    left: 0,
                    right: 0,
                    child: Builder(builder: (context) {
                      if (i == displayCards.length - 1) {
                        return Draggable(
                          data: i,
                          feedback: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                              width: containerWidth *
                                  0.6, // Set the same width as the child
                              height: containerHeight *
                                  0.45, // Set the same height as the child
                            ),
                            child: displayCards[i],
                          ),
                          childWhenDragging: const SizedBox.shrink(),
                          child: displayCards[i],
                        );
                      }
                      return Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.15 * (displayCards.length - i)),
                            borderRadius:
                            BorderRadius.circular(11.0),
                          ),
                          child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.15 * (displayCards.length - i)), // Tint color for contents
                              BlendMode.srcATop, // Blend mode for tinting
                            ),
                            child: displayCards[i],
                          ),
                      );
                    })),
            ],
          ),
        ),
      ],
    );
  }
}

class SongCard extends StatefulWidget {
  const SongCard({super.key, required this.cardData});

  final Poll cardData;

  @override
  State<StatefulWidget> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    const double aspectRatio = 2 / 3;

    final maxHeight = screenHeight;
    final maxWidth = maxHeight * aspectRatio;

    final containerWidth = maxWidth > screenWidth ? screenWidth : maxWidth;
    final containerHeight = containerWidth / aspectRatio;

    Song pollSong = widget.cardData.song;

    return Card(
      margin: const EdgeInsets.all(0),
      color: Colors.blue,
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(containerWidth *
                0.01), // Adjust the padding value as needed
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(widget.cardData.song.imageUrl),
                ),
                Positioned(
                  top: 0, // Align to the top
                  right: 0, // Align to the right
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: containerWidth * 0.16,
                      maxHeight: containerWidth * 0.2,
                    ),
                    child: RingChart(votes: [widget.cardData.upvotes, widget.cardData.downvotes], size: containerWidth * 0.1,),
                  ),
                ),
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(containerHeight * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pollSong.title,
                  style: TextStyle(fontSize: containerWidth * 0.03),
                ),
                Text(
                  pollSong.artists.toString().substring(1, pollSong.artists.toString().length - 1),
                  style: TextStyle(fontSize: containerWidth * 0.03),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

