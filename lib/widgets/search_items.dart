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
  List<String> songItems = List.generate(50, (index) => 'Song $index');
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
  List<MediaItemData> searchedItems = [];

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchedItems = List.from(mediaItems);
  }

  void search(String searchedSong) {
    setState(() {
      searchedItems = searchedSong.isEmpty
          ? List.from(mediaItems)
          : mediaItems
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
                child: MediaItemList(
                  mediaItems: searchedItems
                      .map((item) => MediaItem(
                    itemData: item,
                    onTap: () {
                      widget.onMediaItemSelected(item);
                      Navigator.pop(context);
                    },
                  ))
                      .toList(),
                ),
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
