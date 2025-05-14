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
    final artistNames = (json['artists'] as List).isNotEmpty
        ? (json['artists'] as List).cast<String>()
        : ['Unknown Artist'];

    final imageUrl = (json['imageUrl'] as String) ?? 'lib/assets/trackPlaceHolder.png';

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
