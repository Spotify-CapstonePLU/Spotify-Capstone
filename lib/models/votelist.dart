import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/models/postgres_interval.dart';

class Votelist extends MediaItemData {
  final PostgresInterval maxPollDuration;
  final PostgresInterval minPollTimeout;
  final String playlistId;

  Votelist(
      {required super.title,
      required super.details,
      required this.playlistId,
      required this.maxPollDuration,
      required this.minPollTimeout});

  factory Votelist.fromJson(Map<String, dynamic> json) {
    return Votelist(
        title: json['playlist_name'],
        details: 'votelist',
        playlistId: json['playlist_id'],
        maxPollDuration: PostgresInterval.fromJson(json['max_poll_duration']),
        minPollTimeout: PostgresInterval.fromJson(json['min_poll_timeout']));
  }

  @override
  String toString() {
    return '[Title: $title, Details: $details, ItemId: $playlistId, Duration: ${maxPollDuration.days}, Timeout: ${minPollTimeout.days}]';
  }
}
