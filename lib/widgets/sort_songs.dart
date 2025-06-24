import 'package:flutter/material.dart';
import 'package:spotify_polls/models/song.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/widgets/media_item_list.dart';

class SortSongs extends StatefulWidget {
  const SortSongs({
    super.key,
    this.title = "Sort Songs",
    required this.songs,
  });
  final String title;
  final List<Song> songs;

  @override
  State<SortSongs> createState() => _SortSongsState();
}

class _SortSongsState extends State<SortSongs> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: MediaItemList(listData: widget.songs),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }
}
