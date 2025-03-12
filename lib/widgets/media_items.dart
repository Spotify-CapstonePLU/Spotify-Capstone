import 'package:flutter/material.dart';

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
          border: Border.all(color: Colors.blueAccent),
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


class MediaItemData {
  const MediaItemData({
    required this.title,
    required this.details,
    this.imageUrl =
        "https://th.bing.com/th/id/R.e78f8e7c326d3e7cdcf053d58f494542?rik=bXopo7rm0XIdFQ&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2fc%2fc7%2fDomestic_shorthaired_cat_face.jpg&ehk=NByReFekRNa%2fCe0v9gNPEb0tpYmVhy4kI5uaC1l1AUI%3d&risl=1&pid=ImgRaw&r=0",
    this.onTap,
  });

  final String title;
  final String details;
  final String imageUrl;
  final VoidCallback? onTap;
}
