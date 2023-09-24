import 'package:flutter/material.dart';
import 'package:timeline_editor/editable_timeline.dart';

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  Widget? barBuilder(BuildContext ctx, int index) {
    final int i = index + 1;
    if (i % 8 == 0) {
      return SizedBox(
        width: 0,
        child: Text(
          "${(i / 8).truncate()}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      return SizedBox(width: 0, child: Text("${i % 8}"));
    }
  }

  void _showIndex(int ind, BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) {
        return SimpleDialog(
          title: const Text(
            "Details",
          ),
          children: [Center(child: Text("Details for $ind"))],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tStyle = TimelineEditorStyle(
        timelineAndBarHeight: 150,
        tilePadding:
            const EdgeInsets.only(top: 8, bottom: 8, left: 2, right: 2),
        timelineDecoration: BoxDecoration(
            color: const Color.fromARGB(255, 238, 238, 238),
            border: Border.all(
              color: const Color.fromARGB(255, 1, 12, 167),
              width: 3,
            )));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _controller.addTile(TimedTile(
                child: Container(
                  // color: Colors.purple,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                        Color.fromARGB(255, 102, 23, 141),
                        Color.fromARGB(255, 183, 87, 231)
                      ])),
                  child: Center(
                      child: Text(
                    genName(),
                    maxLines: 1,
                    style: const TextStyle(
                        overflow: TextOverflow.fade,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  )),
                ),
              ))),
      body: Center(
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                EditableTimeline(
                  controller: _controller,
                  // scalingFactor: MediaQuery.of(context).size.width / (8 * 2),
                  totalSteps: 8,
                  underBarBuilder: barBuilder,
                  popupMenuItemsBuilder: (int index) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            _showIndex(index, context);
                          },
                          child: const Row(
                            children: [Icon(Icons.details), Text("Details")],
                          )),
                    ];
                  },
                  style: tStyle,
                ),
                TimelineViewer(
                  tiles: _controller.tiles,
                  underBarBuilder: barBuilder,
                  totalSteps: 8,
                  style: tStyle,
                  directDoubleClickAction: (i) {
                    _showIndex(i, context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
