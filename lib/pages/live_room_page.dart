import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/control_bar.dart';
import 'package:spotify_polls/widgets/song_cards.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/widgets/song_drawer.dart';
import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/widgets/voting.dart';
import 'package:spotify_polls/pages/voting_page.dart';

class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage({super.key, this.title = "Live Room"});

  final String title;

  @override
  State<LiveRoomPage> createState() => _LiveRoomPageState();
}

class _LiveRoomPageState extends State<LiveRoomPage> {
  final List<MediaItemData> liveQueueData = [
    const MediaItemData(
        title: "song1",
        details: "song1 details",
        imageUrl:
        'https://th.bing.com/th/id/R.e78f8e7c326d3e7cdcf053d58f494542?rik=bXopo7rm0XIdFQ&riu=http%3a%2f%2fupload.wikimedia.org%2fwikipedia%2fcommons%2fc%2fc7%2fDomestic_shorthaired_cat_face.jpg&ehk=NByReFekRNa%2fCe0v9gNPEb0tpYmVhy4kI5uaC1l1AUI%3d&risl=1&pid=ImgRaw&r=0'),
    const MediaItemData(
        title: "song2",
        details: "song2 details",
        imageUrl:
        'https://static.scientificamerican.com/sciam/cache/file/2AE14CDD-1265-470C-9B15F49024186C10_source.jpg?w=1200'),
  ];

  final List<SongCardData> _songCards = [];

  void _addSong() {
    setState(() {
      _songCards.insert(
          0,
          SongCardData(
            songName: "Song ${_songCards.length + 1}",
            artistNames: "Artist ${_songCards.length + 1}",
            trackArt: "assets/trackArtPlaceholder.png",
            votes: [0, 0], // Placeholder art
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double shortestSide = MediaQuery.sizeOf(context).shortestSide;

    void voteYes() {
      _songCards[_songCards.length - 1].votes[0] += 1;
    }

    void voteNo() {
      _songCards[_songCards.length - 1].votes[1] += 1;
    }

    return Scaffold(
      endDrawer: SongDrawer(data: liveQueueData),
      appBar: CustomAppBar(title: widget.title),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Voting(initSongCards: _songCards),
                const SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => const VotingPage()),
                //     );
                //   },
                //   child: const Text("Go to Voting Page"),
                // ),
                const SizedBox(height: 20),
                ControlBar(size: shortestSide)
              ],
            ),
      ],
    ));
  }
}
