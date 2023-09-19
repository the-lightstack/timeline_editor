import 'package:flutter/material.dart';
import 'package:timeline_editor/timeline.dart';
import 'package:timeline_editor/timeline_editor.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final EditableTimelineController _controller = EditableTimelineController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _controller.addTile(TimedTile(
                child: const Text("New Tile"), startPosition: 1, length: 4))),
        body: Center(
          child: EditableTimeline(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
