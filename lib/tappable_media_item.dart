import 'package:flutter/material.dart';
import 'package:spotify_polls/media_items.dart';
import 'package:spotify_polls/pages/voting_page.dart';

class TappableMediaItem extends StatefulWidget {
  const TappableMediaItem ({super.key,
  required this.itemData,
    this.onTap
  });

  final Function? onTap;
  final MediaItemData itemData;

  @override
  State<StatefulWidget> createState() => _TappableMediaItemState();
}

class _TappableMediaItemState extends State<TappableMediaItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap!;
        }
      },
      child: MediaItem(itemData: widget.itemData),
    );
  }
}