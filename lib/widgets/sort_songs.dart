
import 'package:flutter/material.dart';

class SortSongs extends StatefulWidget{
  const SortSongs({
    super.key,
    this.title = "Sort Songs"
  });
  final String title;

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
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

        ],)
      ),
    );
  }
}