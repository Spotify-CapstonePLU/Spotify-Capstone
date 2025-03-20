import 'package:flutter/material.dart';
import 'package:spotify_polls/widgets/song_cards.dart';

class SortSongs extends StatefulWidget{
  const SortSongs({
    super.key,
    this.title = "Sort Songs",
    required this.songCards,
    required this.onSongSelected,
  });
  final String title;
  final List<SongCardData> songCards;
  final Function(int) onSongSelected;

  @override
  State<SortSongs> createState() => _SortSongsState();
}

class _SortSongsState extends State<SortSongs>{
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 18),),
            const SizedBox(height:  10,),
            SizedBox(
              height: 300,
              child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: widget.songCards.length,
                  itemBuilder: (_, index){
                    var card = widget.songCards[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: card.trackArt,
                      ),
                      title: Text(card.songName),
                      subtitle: Text(card.artistName),
                      onTap: () {
                        widget.onSongSelected(index);
                      },
                    );
                  }
              ),
            )
          ],
        )
      ),
    );
  }
}