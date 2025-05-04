import 'dart:convert';

import 'package:spotify_polls/models/media_item.dart';

class Song extends MediaItemData {
  final String artist;
  final String songId;

  Song(
      {required super.title,
      required super.details,
      required super.imageUrl,
      required this.artist,
      required this.songId});

  factory Song.fromJson(Map<String, dynamic> json) {
    final artistName = (json['artists'] as List).isNotEmpty
        ? json['artists'][0]['name'] as String
        : 'Unknown Artist';

    final imageList = json['album']['images'] as List;
    final imageUrl = imageList.isNotEmpty
        ? imageList.last['url'] as String
        : 'lib/assets/trackPlaceHolder.png';

    return Song(
        title: json['name'] as String,
        details: 'Song',
        songId: json['id'],
        artist: artistName,
        imageUrl: imageUrl);
  }

  static List<Song> parseSongFromSearchResults(String response) {
    final Map<String, dynamic> jsonMap = jsonDecode(response);
    final items = jsonMap['tracks']['items'] as List<dynamic>;

    return items
        .map((item) => Song.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
