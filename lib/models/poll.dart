import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/models/postgres_interval.dart';

class Poll {
  final String playlistId;
  final String pollId;
  final String songId;
  final String type;
  final int upvotes;
  final int downvotes;
  final DateTime startTime;
  final DateTime endTime;

  Poll({
    required this.playlistId,
    required this.pollId,
    required this.songId,
    required this.type,
    required this.upvotes,
    required this.downvotes,
    required this.startTime,
    required this.endTime,
  });

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
        playlistId: json['playlist_id'],
        pollId: json['poll_id'],
        songId: json['song_id'],
        type: json['type'],
        upvotes: json['upvotes'],
        downvotes: json['downvotes'],
        startTime: json['start_time'],
        endTime: json['end_time'],);
  }

  @override
  String toString() {
    return '[playlistId: $playlistId, pollId: $pollId, songId: $songId, type: $type, upvotes: $upvotes, downvotes: $downvotes, startTime: $startTime, endTime: $endTime]';
  }
}
