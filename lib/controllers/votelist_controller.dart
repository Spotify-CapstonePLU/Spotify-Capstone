import 'dart:convert';
import 'dart:developer';
import 'dart:html';

import 'package:spotify_polls/models/votelist.dart';

class VotelistController {
  static const String baseUrl = "http://127.0.0.1:3000";

  Future<List<Votelist>> getVotelists() async {
    print('Called getVotelists() function.');
    final request = await HttpRequest.request(
      '$baseUrl/votelists',
      method: 'GET',
      requestHeaders: {'Content-Type': 'application/json'},
      withCredentials: true,
    );

    print('Received response from GET call.');
    if (request.status == 200) {
      log('Successful response status');
      final List<dynamic> data = jsonDecode(request.responseText!);
      final votelists = data.map((item) => Votelist.fromJson(item)).toList();
      print(votelists.toString());
      return votelists;
    } else {
      log('Failed with status: ${request.status}');
      return [];
    }
  }

  Future<Votelist> createVotelist(String name) async {
    print('Called createVotelist() function.');

    final request = await HttpRequest.request('$baseUrl/votelists/create',
        method: 'POST',
        requestHeaders: {'Content-Type': 'application/json'},
        withCredentials: true,
        sendData: jsonEncode({
          'playlist_name': name,
        }));

    if (request.status == 201) {
      return Votelist.fromJson(
          jsonDecode(request.responseText!) as Map<String, dynamic>);
    } else {
      throw Exception(
          'Failed to create Votelist with status: ${request.status}');
    }
  }
}
