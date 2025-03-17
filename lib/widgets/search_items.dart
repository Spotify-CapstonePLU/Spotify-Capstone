import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/media_items.dart';

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
  List<MediaItemData> mediaItems = [
    const MediaItemData(title: "Song A", details: "Artist A"),
    const MediaItemData(title: "Song B", details: "Artist B"),
    const MediaItemData(title: "Song C", details: "Artist C"),
    const MediaItemData(title: "Song D", details: "Artist C"),
    const MediaItemData(title: "Song E", details: "Artist D"),
    const MediaItemData(title: "Song F", details: "Artist E"),
    const MediaItemData(title: "Song G", details: "Artist F"),
    const MediaItemData(title: "Song H", details: "Artist F"),
    const MediaItemData(title: "Song A", details: "Artist F"),
  ];
  List<MediaItemData> allMediaItems = [];
  List<MediaItemData> filteredItems = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    allMediaItems = [
      MediaItemData(
        title: "Song A",
        details: "Artist X",
        onTap: () {
          widget.onMediaItemSelected(const MediaItemData(
            title: "Song A",
            details: "Artist X",
            imageUrl:
            "https://upload.wikimedia.org/wikipedia/commons/c/c7/Domestic_shorthaired_cat_face.jpg",
          ));
          Navigator.pop(context);
        },
      ),
      MediaItemData(
        title: "Song B",
        details: "Artist Y",
        onTap: () {
          widget.onMediaItemSelected(const MediaItemData(
            title: "Song B",
            details: "Artist Y",
          ));
          Navigator.pop(context);
        },
      ),
    ];
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
            ])
        )
    );
  }
}
//
// class SongOptions{
//   String songName;
//   String artist;
//   SongOptions({this.songName, this.artist})
// }
