import 'dart:async';
import 'dart:convert';
import 'package:universal_html/html.dart';

import 'package:flutter/cupertino.dart';
import 'package:spotify_polls/models/song.dart';
import 'package:spotify_polls/services/websocket_service.dart';

import '../models/poll.dart';

class VotingController with ChangeNotifier {
  static const String baseUrl = 'http://127.0.0.1:3000';
  static const String wsUrl = 'ws://127.0.0.1:3000';
  final WebSocketService _pollWsService = WebSocketService();
  final WebSocketService _votingWsService = WebSocketService();
  final StreamController<String> _pollMessagesController =
      StreamController<String>.broadcast();

  Stream<String> get messages => _pollMessagesController.stream;

  void connectSockets() {
    _pollWsService.connect("$wsUrl/voting/polls");
    _votingWsService.connect("$wsUrl/voting");

    _pollWsService.stream.listen((data) {
      final decoded = jsonDecode(data);
      print(decoded);
      // if (decoded['type'] == 'poll_data') {
      //   _pollMessagesController.add(decoded['message']);
      // }
    });
  }

  void disconnectSockets() {
    _pollWsService.disconnect();
    _votingWsService.disconnect();
  }

  // should be websocket
  void castVote(String vote, String pollId) async {
    final message = {
      "type": vote,
      "pollId": pollId,
      "id": DateTime.now().millisecondsSinceEpoch.toString() // simple unique ID
    };

    _votingWsService.send(jsonEncode(message));
  }

  Future<List<Poll>> getPolls(String playlistId) async {
    final request = await HttpRequest.request(
      '$baseUrl/voting/polls/$playlistId',
      method: 'GET',
      requestHeaders: {'Content-Type': 'application/json'},
      withCredentials: true,
    );
    if (request.status! < 400 && request.status! >= 100) {
      final List<dynamic> data = jsonDecode(request.responseText!);
      final polls = data.map((item) => Poll.fromJson(item)).toList();
      return polls;
    } else {
      print('Failed with status: ${request.status}');
      return [];
    }
  }

  Future<bool> createPoll(String songId, String playlistId) async {
    try {
      final HttpRequest response = await HttpRequest.request(
        '$baseUrl/voting/polls/create',
        method: 'POST',
        requestHeaders: {'Content-Type': 'application/json'},
        withCredentials: true,
        sendData: jsonEncode({
          'song_id': songId,
          'playlist_id': playlistId,
        }),
      );


      return response.status == 200;
    } catch (error, stackTrace) {
      print("Something went wrong while creating poll:");
      print("Error: $error");
      print("Stack trace: $stackTrace");

      return false;
    }
  }

  Future<List<Song>> searchSongs(String query) async {
    final uri = Uri.parse('$baseUrl/voting/search')
        .replace(queryParameters: {'song': query});

    final response = await HttpRequest.request(uri.toString(),
        method: 'GET',
        requestHeaders: {'Content-Type': 'application/json'},
        withCredentials: true);

    if (response.status == 200) {
      return Song.parseSongFromSearchResults(response.responseText!);
    } else {
      throw Exception(
          'Error searching for the song with status: ${response.status}');
    }
  }
}
