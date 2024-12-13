import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SongCards extends StatefulWidget {
  const SongCards({
    super.key,
    required this.songs,
    required this.onAdd,
  });

  final List<String> songs;
  final VoidCallback onAdd;

  @override
  State<StatefulWidget> createState() => _SongCardsState();
}

class _SongCardsState extends State<SongCards> {

  @override
  Widget build(BuildContext context) {
    const double boxWidth = 600;
    const double boxHeight = 700;
    const double overlapOffset = 20; // Vertical spacing for the stack
    const int displayListMax = 5;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stack container
        SizedBox(
          width: boxWidth,
          height: (5 * overlapOffset) + boxHeight,
          child: Stack(// Allow overflow for stack positioning
            children: [
              // Render boxes in the correct order for z-axis layering
              for (int i = (widget.songs.length > displayListMax ? displayListMax : widget.songs.length) - 1; i >= 0; i--)
                Positioned(
                  // The first item will appear in front and others will be behind
                  bottom: (i * 20), // Controls vertical offset
                  child: Container(
                    width: boxWidth,
                    height: boxHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color.lerp(
                        Colors.blue[300]!,  // Brightest color (for the oldest box)
                        Colors.blue[900]!,  // Darkest color (for the newest box)
                        i / (displayListMax - 1),  // Adjust interpolation
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Text(
                      widget.songs[i],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20), // Spacing between the stack and the button
        // Add Box button
        ElevatedButton(
          onPressed: widget.onAdd,
          child: const Text("Add Box"),
        ),
      ],
    );

  }
}
