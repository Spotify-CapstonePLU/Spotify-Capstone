import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:spotify_polls/models/song.dart';
import 'package:spotify_polls/services/voting_websocket_service.dart';

class VotingController with ChangeNotifier{
  static const String baseUrl = 'http://127.0.0.1:3000';
  final VotingWebSocketService _wsService = VotingWebSocketService();
  final List<String> _messages = [];


  List<String> get messages => List.unmodifiable(_messages);

  void connectSocket() {
    _wsService.connect();
    _wsService.stream.listen((data) {
      final decoded = jsonDecode(data);
      if (decoded['type'] == 'ack') {
        _messages.add("ACK: ${decoded['message']}");
        notifyListeners();
      }
    });
  }

  void send(String message) {
    _wsService.send(message);
  }

  void disconnectSocket() {
    _wsService.disconnect();
  }

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

  // should be websocket
  void castVote(String vote, String pollId) async {
    final message = {
      "type": vote,
      "pollId": pollId,
      "id": DateTime.now().millisecondsSinceEpoch.toString() // simple unique ID
    };

    _wsService.send(jsonEncode(message));
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
