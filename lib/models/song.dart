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
        : 'https://th.bing.com/th/id/R.e78f8e7c326d3e7cdcf053d58f494542?rik=bXopo7rm0XIdFQ&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2fc%2fc7%2fDomestic_shorthaired_cat_face.jpg&ehk=NByReFekRNa%2fCe0v9gNPEb0tpYmVhy4kI5uaC1l1AUI%3d&risl=1&pid=ImgRaw&r=0';

    return Song(
        title: json['name'] as String,
        details: artistName,
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
