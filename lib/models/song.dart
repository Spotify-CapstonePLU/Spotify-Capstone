import 'dart:convert';

import 'package:spotify_polls/models/media_item.dart';

class Song extends MediaItemData {
  final List<String> artists;
  final String songId;

  Song(
      {required super.title,
      required super.details,
      required super.imageUrl,
      required this.artists,
      required this.songId});

  factory Song.fromJson(Map<String, dynamic> json) {
    final artistNames = (json['artists'] as List<dynamic>).map((artist) {
      if (artist is String) return artist;
      if (artist is Map<String, dynamic>) return artist['name'] as String? ?? 'Unknown Artist';
      return 'Unknown Artist';
    }).toList();

    final imageUrl = json['imageUrl']?.toString() ?? 'lib/assets/trackPlaceHolder.png';

    return Song(
        title: json['title'] as String,
        details: 'Song',
        songId: json['song_id'],
        artists: artistNames,
        imageUrl: imageUrl);
  }

  static List<Song> parseSongFromSearchResults(String response) {
    final List<dynamic> jsonMap = jsonDecode(response);
    final items = jsonMap;

    return items
        .map((item) => Song.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
