import 'package:flutter/material.dart';
import 'package:spotify_polls/controllers/voting_controller.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/widgets/song_cards.dart';
import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/widgets/search_items.dart';
import 'package:spotify_polls/widgets/voting.dart';

import '../models/poll.dart';
import '../widgets/song_drawer.dart';
import '../widgets/sort_songs.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key, this.title = "Voting Page", required this.playlistId});
  final String playlistId;
  final String title;

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  final List<SongCardData> _songCards = [];
  late Future<List<Poll>> _pollsFuture;
  late Key _votingWidgetKey = UniqueKey();

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
      _votingWidgetKey = UniqueKey();
    });
  }

  void _sortSongs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SortSongs(
          mediaItems: _songCards.map((songCardData) {
            return MediaItemData(
              title: songCardData.songName,
              details: songCardData.artistName,
              imageUrl: songCardData.trackArt,
              onTap: () {
                setState(() {
                  _songCards.remove(songCardData);
                  _songCards.add(songCardData);
                  _votingWidgetKey = UniqueKey();
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
  void initState() {
    super.initState();
    _pollsFuture = VotingController().getPolls(widget.playlistId);
    VotingController().connectSockets();
    // connect to websocket for getting polls
    // connect to websocket for voting
  }

  @override
  void dispose() {
    VotingController().disconnectSockets();
    super.dispose();
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
              Voting(key: _votingWidgetKey, initSongCards: _songCards),
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
