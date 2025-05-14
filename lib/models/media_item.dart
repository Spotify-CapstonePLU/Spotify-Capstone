import 'dart:ui';

class MediaItemData {
  static const String defaultImageUrl = "lib/assets/trackArtPlaceholder.png";

  const MediaItemData({
    required this.title,
    required this.details,
    this.imageUrl = defaultImageUrl,
    this.onTap,
  });

  final String title;
  final String details;
  final String imageUrl;
  final VoidCallback? onTap;
}