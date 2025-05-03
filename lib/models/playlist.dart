import 'package:spotify_polls/models/media_item.dart';

class Playlist extends MediaItemData {
  final String playlistId;

  const Playlist({
    required this.playlistId,
    required super.title,
    required super.details,
    super.imageUrl,
    super.onTap,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      title: json['name'],
      details: '',
      playlistId: json['id'],
      imageUrl: json['imageUrl'] ?? MediaItemData.defaultImageUrl,
    );
  }

  @override
  String toString() {
    return '[Title: $title, Details: $details, ItemId: $playlistId, imageUrl: $imageUrl]';
  }
}
