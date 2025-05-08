import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/media_item_list.dart';
import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/controllers/voting_controller.dart';

import '../models/song.dart';

class SearchItems extends StatefulWidget {
  const SearchItems({
    super.key,
    this.title = "Search for Songs",
    this.playlistId = "",
  });
  final String title;
  final String playlistId;


  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  Timer? _debounce;
  //List<MediaItemData> allMediaItems = [];
  List<MediaItemData> searchResults = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  MediaItemData songToMedia(Song song) {
    return MediaItemData(
      title: song.title,
      details: '${song.details} by ${song.artist}',
      imageUrl: song.imageUrl,
      onTap: () {
        void handleCreatePoll() async {
          print("attempt to create poll");
          bool success = await VotingController().createPoll(song.songId, widget.playlistId);

          if (success) {
            print('Poll created successfully!');
            // You can also update the UI with setState here if needed
          } else {
            print('Failed to create poll.');
          }
        }
        handleCreatePoll();
      },
    );
  }

  Future<void> search(String query) async {
    try {
      final response = await VotingController().searchSongs(query);
      setState(() {
        searchResults = response.map(songToMedia).toList();
      });
      print('Finished search');
    } catch (error) {
      print('Error: $error');
    }
  }

  void _onSearchChanged(String query) {
    if(_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      if(query.isNotEmpty) {
        search(query);
      } else {
        setState(() {
          searchResults = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search for a song...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (query) {
                  _onSearchChanged(query);
                  },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: MediaItemList(listData: searchResults),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ])));
  }
}
