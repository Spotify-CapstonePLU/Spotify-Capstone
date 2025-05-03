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
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                var curData = widget.listData[index];
                return Material(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start, // Allows image to be taller
                      children: [
                        SizedBox(
                          width: 75,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              curData.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network('lib/assets/trackArtPlaceholder.png');
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(curData.title),
                              const SizedBox(height: 4),
                              Text(curData.details),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
              separatorBuilder: (_, __) => const SizedBox(
                height: 10,
              ),
              itemCount: widget.listData.length,
            ),
          )
        )
    );
  }
}
