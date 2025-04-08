import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/media_item_list.dart';
import 'package:spotify_polls/models/media_item.dart';

class SearchItems extends StatefulWidget {
  const SearchItems({
    super.key,
    this.title = "Search for Songs",
    required this.onMediaItemSelected,
  });
  final String title;

  final Function(MediaItemData) onMediaItemSelected;

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  List<MediaItemData> allMediaItems = [];
  List<MediaItemData> filteredItems = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    List<MediaItemData> baseItems = [
      const MediaItemData(
        title: "Song A",
        details: "Artist X",
        imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/c/c7/Domestic_shorthaired_cat_face.jpg",
      ),
      const MediaItemData(
        title: "Song B",
        details: "Artist Y",
      ),
    ];

    allMediaItems = baseItems.map((item) {
      return MediaItemData(
        title: item.title,
        details: item.details,
        imageUrl: item.imageUrl,
        onTap: () {
          widget.onMediaItemSelected(item);
          Navigator.pop(context);
        },
      );
    }).toList();

    filteredItems = List.from(allMediaItems);
  }

  void search(String searchedSong) {
    setState(() {
      filteredItems = searchedSong.isEmpty
          ? List.from(allMediaItems)
          : allMediaItems
              .where((item) =>
                  item.title.toLowerCase().contains(searchedSong.toLowerCase()))
              .toList();
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
                onChanged: search,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: MediaItemList(listData: filteredItems),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ])));
  }
}
//
// class SongOptions{
//   String songName;
//   String artist;
//   SongOptions({this.songName, this.artist})
// }
