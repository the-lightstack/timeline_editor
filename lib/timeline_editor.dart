library timeline_editor;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:timeline_editor/timeline.dart';
import 'package:timeline_editor/timeline_tile.dart';
import 'package:collection/collection.dart';

class EditableTimeline extends StatefulWidget {
  final EditableTimelineController controller;
  final int totalSteps;

  const EditableTimeline(
      {super.key, required this.controller, this.totalSteps = 20});

  @override
  State<EditableTimeline> createState() => _EditableTimelineState();
}

class _EditableTimelineState extends State<EditableTimeline> {
  void _renderScreen() {
    print("Render again!");
    setState(() {});
  }

  @override
  void initState() {
    widget.controller.addListener(_renderScreen);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_renderScreen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<TimelineTile> ttiles = <TimelineTile>[
      for (int i = 0; i < widget.controller.tiles.length; i++)
        TimelineTile(
          key: UniqueKey(),
          tileData: widget.controller.tiles[i],
          controller: widget.controller,
          totalSteps: widget.totalSteps,
          ownIndex: i,
        )
    ];
    return SizedBox(
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Container(
            color: Colors.blue,
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              onReorder: widget.controller._reorderTiles,
              children: ttiles,
            )));
  }
}

/// The developer uses this to interact with the [EditableTimeline] . You can
/// listen to changes as well as add and modify the [TimedTile]s
/// TODO: auto scroll to new tile after adding it
class EditableTimelineController extends ValueNotifier<TimelineEntity> {
  final int defaultTileLength;
  EditableTimelineController({this.defaultTileLength = 5})
      : super(TimelineEntity());

  @visibleForTesting
  int computeStartPosition(int index) {
    return value.tiles
        .getRange(0, index)
        .map((e) => e.length!)
        .toList(growable: false)
        .sum;
  }

  List<TimedTile> get tiles => value.tiles;
  void addTile(TimedTile t) {
    TimedTile correctTile = TimedTile.internal(
        index: value.tiles.length,
        startPosition: computeStartPosition(value.tiles.length),
        length: defaultTileLength,
        child: t.child);
    value.addTile(correctTile);
    notifyListeners();
  }

  void changeTileLength(int index, int newLength) {
    value.tiles[index].length = newLength;

    // For all higher indices update startpos
    for (int i = index; i < value.tiles.length; i++) {
      value.tiles[i].startPosition = computeStartPosition(i);
    }
  }

  void _reorderTiles(int oldIndex, int newIndex) {
    // If this doesn't work, do:
    // 1) get oldIndex
    // 2) insert to new index
    // 3) delete old index

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final temp = value.tiles.removeAt(oldIndex);
    value.tiles.insert(newIndex, temp);

    notifyListeners();
  }
}
