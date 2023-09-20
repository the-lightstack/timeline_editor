import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeline_editor/timeline.dart';
import 'package:timeline_editor/timeline_editor.dart';

void main() {
  runApp(const MainApp());
}

// random words to have names for tiles
const wordList = [
  "consider",
  "minute",
  "accord",
  "evident",
  "practice",
  "intend",
  "concern",
  "commit",
  "issue",
  "approach",
  "establish",
  "utter",
  "conduct",
  "engage",
  "obtain",
];

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final EditableTimelineController _controller =
      EditableTimelineController(defaultTileLength: 4);
  int counter = 0;

  String genName() {
    final s = wordList[counter % wordList.length];
    setState(() {
      counter = counter + 1;
    });
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _controller.addTile(TimedTile(
                  child: Text(genName()),
                ))),
        body: Center(
          child: EditableTimeline(
            controller: _controller,
            scalingFactor: MediaQuery.of(context).size.width / (8 * 3),
          ),
        ),
      ),
    );
  }
}
