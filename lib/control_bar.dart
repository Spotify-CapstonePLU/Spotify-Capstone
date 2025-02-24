import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ControlBar extends StatefulWidget {
  const ControlBar({
    super.key, required this.size
  });

  final double size;

  @override
  State<StatefulWidget> createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {

  bool playState = false;

  void togglePlayState() {
    setState(() {
      playState = !playState;
    });
  }

  @override
  Widget build(BuildContext context) {
    double buttonIconSize = widget.size * 0.09;

    ButtonStyle playerButtonStyle = ElevatedButton.styleFrom(
        padding: EdgeInsets.all(widget.size * 0.01),
        minimumSize: const Size.square(1));

    ButtonStyle queueButtonStyle = ElevatedButton.styleFrom(
        padding: EdgeInsets.all(widget.size * 0.01),
        minimumSize: const Size.square(1),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: widget.size * 0.02),
          margin: EdgeInsets.all(widget.size * 0.01),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.indigoAccent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Wrap(
            // Control bar
            alignment: WrapAlignment.center,
            spacing: widget.size * 0.02,
            children: [
              ElevatedButton(
                  style: playerButtonStyle,
                  onPressed: () {},
                  child: Icon(Icons.skip_previous,
                      size: buttonIconSize)),
              ElevatedButton(
                style: playerButtonStyle,
                onPressed: togglePlayState,
                child: Icon(playState ? Icons.pause : Icons.play_arrow,
                    size: buttonIconSize),
              ),
              ElevatedButton(
                  style: playerButtonStyle,
                  onPressed: () {},
                  child: Icon(Icons.skip_next,
                      size: buttonIconSize)),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(0, widget.size * 0.03 , 0, 0),
          child: ElevatedButton(
              style: queueButtonStyle,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              child:
              Icon(Icons.queue_music, size: buttonIconSize)),
        )
      ],
    );
  }
}