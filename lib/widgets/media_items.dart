import 'package:flutter/material.dart';

class MediaItemList<Widget> extends StatefulWidget {
  const MediaItemList({
    super.key,
    required this.mediaItems,
  });

  final List<MediaItem> mediaItems;

  @override
  State<StatefulWidget> createState() => _MediaItemListState();

  void add(MediaItemData itemData, [VoidCallback? onTap]) {
    mediaItems.add(MediaItem(itemData: itemData, onTap: onTap));
  }
}

class _MediaItemListState extends State<MediaItemList> {
  @override
  Widget build(BuildContext context) {
    var parentHeight = MediaQuery.sizeOf(context).height;
    return
        SizedBox(
          height: parentHeight * 0.9, // Set a fixed height
          child: ListView(
            children: [
              for (var i = 0; i < widget.mediaItems.length; i++) widget.mediaItems[i],
            ],
          ),
        );
  }
}


class MediaItemData {
  const MediaItemData({
    required this.title,
    required this.details,
    this.imageUrl =
        "https://th.bing.com/th/id/R.e78f8e7c326d3e7cdcf053d58f494542?rik=bXopo7rm0XIdFQ&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2fc%2fc7%2fDomestic_shorthaired_cat_face.jpg&ehk=NByReFekRNa%2fCe0v9gNPEb0tpYmVhy4kI5uaC1l1AUI%3d&risl=1&pid=ImgRaw&r=0",
  });

  final String title;
  final String details;
  final String imageUrl;
}
