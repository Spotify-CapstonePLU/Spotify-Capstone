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

  void _onMediaItemSelected(MediaItemData selectedMedia) {
    print("Song added: ${selectedMedia.title}");
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
          mediaItems: _songCards.map((item) {
            return MediaItemData(
              title: item.songName,
              details: item.artistName,
              imageUrl: item.trackArt,
              onTap: () {
                setState(() {
                  final songToMove = _songCards.firstWhere(
                        (song) => song.songName == item.songName && song.artistName == item.artistName,
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

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchItems(
          onMediaItemSelected: _onMediaItemSelected,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Voting(initSongCards: _songCards),
              ),
              ElevatedButton(
                onPressed: _sortSongs,
                child: const Text("Sort Songs"),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openSearchDialog,
        child: const Text("Search"),
      ),
    );
  }
}
