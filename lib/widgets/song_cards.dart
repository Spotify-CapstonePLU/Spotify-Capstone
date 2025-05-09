import 'package:flutter/material.dart';
import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/widgets/ring_chart.dart';

class SongCardList extends StatefulWidget {
  const SongCardList({
    super.key,
    required this.songCards,
    required this.onAdd,
  });

  final List<SongCardData> songCards;
  final VoidCallback onAdd;

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

    final start = widget.songCards.length > displayListMax ? widget.songCards.length - displayListMax : 0;
    final displayCards = widget.songCards.skip(start).take(displayListMax).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: containerWidth * 0.6,
          height: containerHeight * 0.6,
          child:
          Stack(
            children: [
              for (int i = displayCards.length - 1; i >= 0; i--)
                Positioned(
                    bottom:
                        i * overlapOffset - (i * i * containerHeight * 0.005),
                    left: 0,
                    right: 0,
                    child: Builder(builder: (context) {
                      if ((displayCards.length - 1 - i) ==
                          displayCards.length - 1) {
                        return Draggable(
                          data: (displayCards.length - 1) - i,
                          feedback: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                              width: containerWidth *
                                  0.6, // Set the same width as the child
                              height: containerHeight *
                                  0.45, // Set the same height as the child
                            ),
                            child: SongCard(
                                cardData:
                                    displayCards[displayCards.length - 1 - i],
                                index: i),
                          ),
                          childWhenDragging: const SizedBox.shrink(),
                          child: SongCard(
                              cardData:
                                  displayCards[displayCards.length - 1 - i],
                              index: i),
                        );
                      }
                      return SongCard(
                          cardData: displayCards[displayCards.length - 1 - i],
                          index: i);
                    })),
            ],
          ),
        ),
      ],
    );
  }
}

class SongCard extends StatefulWidget {
  const SongCard({super.key, required this.cardData, required this.index});

  final int index;
  final SongCardData cardData;

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

    return Card(
      margin: EdgeInsets.all(containerWidth * 0.01),
      color: Colors.blue,
      elevation: 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black
              .withOpacity(0.15 * widget.index), // Tint color with opacity
          borderRadius:
          BorderRadius.circular(11.0), // Match card's border radius
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black
                .withOpacity(0.15 * widget.index), // Tint color for contents
            BlendMode.srcATop, // Blend mode for tinting
          ),
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
                      child: Image.network(widget.cardData.trackArt),
                    ),
                    Positioned(
                      top: 0, // Align to the top
                      right: 0, // Align to the right
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: containerWidth * 0.16,
                          maxHeight: containerWidth * 0.2,
                        ),
                        child: RingChart(votes: widget.cardData.votes, size: containerWidth * 0.1,),
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
                      widget.cardData.songName,
                      style: TextStyle(fontSize: containerWidth * 0.03),
                    ),
                    Text(
                      widget.cardData.artistName,
                      style: TextStyle(fontSize: containerWidth * 0.03),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SongCardData extends MediaItemData{
  const SongCardData({
    required this.songName,
    required this.artistName,
    required String trackArt,
    required this.votes,
  }) : super(
    title: songName,
    details: artistName,
    imageUrl: trackArt,
  );

  final String songName;
  final String artistName;
  String get trackArt => imageUrl;
  final List<double> votes;
}
