import 'dart:ui';

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