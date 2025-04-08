import 'dart:html';

import 'package:spotify_polls/models/song.dart';
import 'package:spotify_polls/models/media_item.dart';

class SearchController {
  static const String baseUrl = '127.0.0.1:3000';

  Future<List<MediaItemData>> searchSongs(String query) async {
    final response = await HttpRequest.request('$baseUrl/voting/search',
        method: 'GET',
        requestHeaders: {'Content-Type': 'application/json'},
        withCredentials: true);

    if (response.status == 200) {
      return Song.parseSongFromSearchResults(response.responseText!);
    } else {
      throw Exception('Error searching for the song with status: ${response.status}');
    }
  }
}
