import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/media_items.dart';

class SongQueue extends StatefulWidget {
  const SongQueue({super.key, required this.data});
  final List<MediaItemData> data;
  @override
  State<StatefulWidget> createState() => _SongQueue();
}

class _SongQueue extends State<SongQueue> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 80,
            child: DrawerHeader( // Remove extra spacing
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double textSize = constraints.maxWidth * 0.1; // Adjust the multiplier as needed
                  return Text(
                    'My Drawer Header',
                    style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
          ),
          for (var itemData in widget.data)
            MediaItem(itemData: itemData)
        ],
      ),
    );
  }
}
