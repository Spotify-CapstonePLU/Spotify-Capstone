import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/widgets/song_cards.dart';
import 'package:spotify_polls/widgets/media_items.dart';
import 'package:spotify_polls/widgets/search_items.dart';
import 'package:spotify_polls/widgets/voting.dart';

import '../widgets/sort_songs.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key, this.title = "Voting Page"});
  final String title;

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final List<SongCardData> _songCards = [];

  List<MediaItemData> get mediaItems => _songCards.map((song) =>
      MediaItemData(
        title: song.songName,
        details: song.artistName,
        imageUrl: song.imageUrl,
      )
  ).toList();

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

  void _onMediaItemSelected(MediaItemData selectedMedia) {
    setState(() {
      _songCards.insert(
        0,
        SongCardData(
          songName: selectedMedia.title,
          artistName: selectedMedia.details,
          trackArt: selectedMedia.imageUrl,
          votes: [0, 0],
        ),
      );
    });
  }

  void _sortSongs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SortSongs(
          mediaItems: mediaItems.map((item) {
            return MediaItemData(
              title: item.title,
              details: item.details,
              imageUrl: item.imageUrl,
              onTap: () {
                setState(() {
                  final songToMove = _songCards.firstWhere(
                        (song) => song.songName == item.title && song.artistName == item.details,
                  );
                  _songCards.remove(songToMove);
                  _songCards.add(songToMove);
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  List<Widget> buttons = [];
  int noCounter = 0;
  int yesCounter = 0;
  @override
  Widget build(BuildContext context) {
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
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DragTarget<int>(
                        builder: (context, candidateData, rejectedData) {
                          return Container(
                            width: 200,
                            height: 200,
                            color: candidateData.isNotEmpty
                                ? Colors.green
                                : Colors.red,
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
                            color: candidateData.isNotEmpty
                                ? Colors.green
                                : Colors.red,
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
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SortSongs(
                            mediaItems: _songCards.map((songCardData) {
                              return MediaItemData(
                                title: songCardData.songName,
                                details: songCardData.artistName,
                                imageUrl: songCardData.imageUrl,
                                onTap: () {
                                  setState(() {
                                    _songCards.remove(songCardData);
                                    _songCards.add(songCardData);
                                  });
                                  Navigator.pop(context);
                                },
                              );
                            }).toList(),
                          );
                        },
                      );
                    },
                    child: const Text("Sort Songs"),
                  ),
                ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SearchItems(
                onMediaItemSelected: (MediaItemData selectedMedia) {
                  setState(() {
                    _songCards.insert(
                      0,
                      SongCardData(
                        songName: selectedMedia.title,
                        artistName: selectedMedia.details,
                        trackArt: selectedMedia.imageUrl,
                        votes: [0, 0],
                      ),
                    );
                  });
                },
              );
            },
          );
        },
        child: const Text("Search"),
      ),
    );
  }
}
