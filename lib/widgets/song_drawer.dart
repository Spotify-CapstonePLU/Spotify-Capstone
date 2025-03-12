import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/media_items.dart';

class SongDrawer extends StatefulWidget {
  const SongDrawer({super.key, required this.data});
  final List<MediaItemData> data;
  @override
  State<StatefulWidget> createState() => _SongDrawer();
}

class _SongDrawer extends State<SongDrawer> {
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
