import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

import 'media_items.dart';

class SortSongs extends StatefulWidget{
  const SortSongs({
    super.key,
    this.title = "Sort Songs",
    required this.mediaItems,
  });
  final String title;
  final List<MediaItemData> mediaItems;

  @override
  State<SortSongs> createState() => _SortSongsState();
}

class _SortSongsState extends State<SortSongs>{
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
              child: MediaItemList(listData: widget.mediaItems),
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