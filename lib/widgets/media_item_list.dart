import 'package:flutter/material.dart';
import 'package:spotify_polls/models/media_item.dart';

class MediaItemList<Widget> extends StatefulWidget {
  const MediaItemList({
    super.key,
    required this.listData,
  });

  final List<MediaItemData> listData;

  @override
  State<StatefulWidget> createState() => _MediaItemListState();

  void add(MediaItemData itemData, [VoidCallback? onTap]) {
    listData.add(MediaItemData(
      title: itemData.title,
      details: itemData.details,
      imageUrl: itemData.imageUrl,
      onTap: onTap,
    ));
  }
}

class _MediaItemListState extends State<MediaItemList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(),
        ),
        child: ClipRRect(
            child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      var curData = widget.listData[index];
                      return Material(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          tileColor: Colors.amber,
                          leading: Image.network(curData.imageUrl),
                          title: Text(curData.title),
                          subtitle: Text(curData.details),
                          onTap: curData.onTap,
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(
                      height: 10,
                    ),
                    itemCount: widget.listData.length,
                  ),
                )));
  }
}
