import 'dart:convert';
import 'dart:html';

import 'package:spotify_polls/models/song.dart';

class VotingController {
  static const String baseUrl = 'http://127.0.0.1:3000';

  Future<bool> createPoll(String songId, String playlistId) async {
    final response = await HttpRequest.request(
      '$baseUrl/voting/polls/create',
      method: 'POST',
      requestHeaders: {'Content-Type': 'application/json'},
      withCredentials: true,
      sendData: jsonEncode({
        'song_id': songId,
        'playlist_id': playlistId,
      }),
    );

    if (response.status == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> castVote(String vote) async {
    final response = await HttpRequest.request('$baseUrl/voting',
    method: 'POST',
    requestHeaders: {'Content-Type': 'application/json'},
    withCredentials: true,
    sendData: jsonEncode({
      'vote': vote,
    }));

    if (response.status == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Song>> searchSongs(String query) async {
    final uri = Uri.parse('$baseUrl/voting/search')
        .replace(queryParameters: {'song': query});

    final response = await HttpRequest.request(
        uri.toString(),
        method: 'GET',
        requestHeaders: {'Content-Type': 'application/json'},
        withCredentials: true
    );

    if (response.status == 200) {
      return Song.parseSongFromSearchResults(response.responseText!);
    } else {
      throw Exception(
          'Error searching for the song with status: ${response.status}');
    }
  }
}
