import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:spotify_polls/controllers/voting_controller.dart';
import 'package:spotify_polls/models/song.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/widgets/search_items.dart';
import 'package:spotify_polls/widgets/voting.dart';

import '../models/poll.dart';
import '../widgets/sort_songs.dart';

class VotingPage extends StatefulWidget {
  const VotingPage({super.key, this.title = "Voting Page", required this.playlistId});
  final String playlistId;
  final String title;

  @override
  State<VotingPage> createState() => _VotingPageState();
}

class _VotingPageState extends State<VotingPage> {
  List<Poll> polls = [];
  late Future<List<Poll>> _pollsFuture;
  late StreamSubscription _votingSubscription;

  List<Song> get songs => polls.map((poll) =>
      poll.song
  ).toList();

  final VotingController votingController = VotingController();

  void _sortSongs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SortSongs(
          songs: songs
        );
      },
    );
  }

  void _openSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SearchItems(
          playlistId: widget.playlistId,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    votingController.connectSockets();
    _pollsFuture = votingController.getPolls(widget.playlistId);
    _votingSubscription = votingController.votingStream.listen((msg) {
      final data = jsonDecode(msg);
      
      print("Voting Page received message: " + data.toString() + "::: end message");
      Poll updatedPoll = Poll.fromJson(data[0]);
      final index = polls.indexWhere((poll) => poll.pollId == updatedPoll.pollId);
      if (index != -1) {
        setState(() {
          polls[index] = updatedPoll;
        });
      }
    });
  }

  @override
  void dispose() {
    votingController.disconnectSockets();
    _votingSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FutureBuilder<List<Poll>>(
                  future: _pollsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      polls = snapshot.data!;

                      if (polls.isEmpty) {
                        return const Center(
                            child: Text('There are no songs to vote on.'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(12),
                          child: Voting(polls: polls, votingController: votingController,),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text("There are no songs to vote on."),
                      );
                    }
                  }
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, MediaQuery.sizeOf(context).height * 0.7, 0, 0) ,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _sortSongs,
                      child: const Text("Sort Songs"),
                    )
                  ],
                )
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openSearchDialog,
        child: const Text("Search"),
      ),
    );
  }
}
