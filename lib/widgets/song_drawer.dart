import 'package:flutter/material.dart';
import 'package:spotify_polls/models/media_item.dart';

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
      child: ListView.separated(
        itemBuilder: (_, index) {
          if (index == 0) {
            return SizedBox(
              height: 80,
              child: DrawerHeader(
                // Remove extra spacing
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double textSize = constraints.maxWidth *
                        0.1; // Adjust the multiplier as needed
                    return Text(
                      'My Drawer Header',
                      style: TextStyle(
                          fontSize: textSize, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
            );
          }
          var curData = widget.data[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              tileColor: Colors.amber,
              leading: Image.network(curData.imageUrl),
              title: Text(curData.title),
              subtitle: Text(curData.details),
              onTap: () => {},
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(
          height: 10,
        ),
        itemCount: widget.data.length + 1,
      ),
    );
  }
}
