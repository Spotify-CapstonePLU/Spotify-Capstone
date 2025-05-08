import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotify_polls/controllers/votelist_controller.dart';
import 'package:spotify_polls/models/votelist.dart';
import 'package:spotify_polls/widgets/custom_app_bar.dart';
import 'package:spotify_polls/pages/live_login_page.dart';
import 'package:spotify_polls/widgets/media_item_list.dart';
import 'package:spotify_polls/models/media_item.dart';
import 'package:spotify_polls/pages/voting_page.dart';
import 'package:spotify_polls/models/playlist.dart';

class VotelistsPage extends StatefulWidget {
  const VotelistsPage({super.key, this.title = "Votelists Page"});

  final String title;

  @override
  State<VotelistsPage> createState() => _VotelistsPageState();
}

class _VotelistsPageState extends State<VotelistsPage> {
  late Future<List<Votelist>> _votelistFuture;
  late Future<List<Playlist>> _playlistFuture;
  bool _isBlurred = false;

  @override
  void initState() {
    super.initState();
    _votelistFuture = VotelistController().getVotelists();
  }
  
  void addCreateVotelist(String name) {
    VotelistController().createVotelist(name);
    setState(() {
      _votelistFuture = VotelistController().getVotelists();
    });
  }
  
  void addRegsiterVotelist(Playlist playlist) {
    print("playlist stuff: ${playlist.playlistId}, ${playlist.title}");
    VotelistController().registerVotelist(playlist.playlistId, playlist.title);
    setState(() {
      _votelistFuture = VotelistController().getVotelists();
    });
  }

  void _toggleBlur() {
    setState(() {
      _isBlurred = !_isBlurred;
    });
  }

  void _showCreatePopup(BuildContext context) async {
    final myController = TextEditingController();

    inputField() {
      return TextField(
        controller: myController,
      );
    }

    submitButton() {
      return FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          Navigator.of(context)
              .pop(myController.text);
          myController.dispose();
        },
        child: const Text("Submit"),
      );
    }

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Create a new votelist", style: TextStyle(fontSize: 18)),
                inputField(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    submitButton(),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     myController.dispose();
                    //     Navigator.of(context).pop();
                    //   },
                    //   child: const Text("Close"),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      addCreateVotelist(result);
    }

    _toggleBlur();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    const double fabHeight = 56.0; // Default FAB height
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final double rightPadding = MediaQuery.of(context).viewPadding.right;

    void showRegisterPopup(BuildContext context) async {
      final result = await showDialog<Playlist>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Register popup", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: screenHeight * 0.7,
                    child: FutureBuilder<List<Playlist>>(
                      future: _playlistFuture,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<Playlist> playlists = snapshot.data!;

                          if(playlists.isEmpty) {
                            return const Center(child: Text('You have no Spotify playlists!'));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: MediaItemList(
                                listData: [
                                  for (var itemData in playlists)
                                    MediaItemData(
                                        title: itemData.title,
                                        details: itemData.details,
                                        imageUrl: itemData.imageUrl,
                                        onTap: () => Navigator.of(context).pop(itemData)
                                    )
                                ],
                              ),
                            );
                          }
                        } else {
                          return const Center(child: Text('You have no Spotify playlists!'));
                        }
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (result != null) {
        print("add playlist?");
        addRegsiterVotelist(result);
      }

      _toggleBlur();
    }

    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: Stack(
        children: [
          GestureDetector(
              onTap: () {
                if (_isBlurred) {
                  log("cancel new votelist");
                  _toggleBlur();
                }
              },
              child: Stack(
                children: [
                  Center(
                    child: FutureBuilder<List<Votelist>>(
                      future: _votelistFuture,
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          List<Votelist> votelists = snapshot.data!;

                          if(votelists.isEmpty) {
                            return const Center(child: Text('You have no registered Votelists!'));
                          } else {
                            return Padding(
                            padding: const EdgeInsets.all(12),
                            child: MediaItemList(
                              listData: [
                                for (var votelist in votelists)
                                  MediaItemData(
                                    title: votelist.title,
                                    details: votelist.details,
                                    imageUrl: votelist.imageUrl,
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VotingPage(playlistId: votelist.playlistId,)
                                      )
                                    ))
                              ],
                            ),
                          );
                          }
                        } else {
                          return const Center(child: Text('You have no registered Votelists!'));
                        }
                      },
                    ),
                  ),
                  if (_isBlurred)
                    BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.transparent,
                        )),
                  if (_isBlurred) ...[
                    Positioned(
                      bottom: fabHeight + bottomPadding + 32.0,
                      right: rightPadding + 16.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _showCreatePopup(context);
                                log("Create Votelist pressed");
                              },
                              child: const Text("Create Votelist")),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {
                                _playlistFuture = VotelistController().getUserPlaylists();
                                showRegisterPopup(context);
                                log("Register Votelist pressed");
                              },
                              child: const Text("Register Votelist")),
                        ],
                      ),
                    ),
                  ],
                ],
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: _toggleBlur,
                child: Text(
                  _isBlurred ? "Close" : "Open Menu",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LiveLoginPage()));
                },
                heroTag: null,
                child: const Text(
                  "LIVE",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
