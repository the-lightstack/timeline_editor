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
  final Widget? Function(BuildContext, int)? underBarBuilder;

  const EditableTimeline(
      {super.key,
      required this.controller,
      this.totalSteps = 20,
      this.underBarBuilder});

  @override
  State<EditableTimeline> createState() => _EditableTimelineState();
}

class _EditableTimelineState extends State<EditableTimeline> {
  void _renderScreen() {
    setState(() {});
  }

  late ScrollController _scrollControllerReorderableList;
  late ScrollController _scrollControllerNamingLine;

  @override
  void initState() {
    widget.controller.addListener(_renderScreen);
    _scrollControllerNamingLine = ScrollController();
    _scrollControllerReorderableList = ScrollController();

    _scrollControllerReorderableList.addListener(() {
      _scrollControllerNamingLine
          .jumpTo(_scrollControllerReorderableList.offset);
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollControllerNamingLine.dispose();
    _scrollControllerReorderableList.dispose();
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
    final int lus = widget.controller.totalLengthUnits();
    return SizedBox(
        height: 100,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                  color: Colors.blue,
                  child: ReorderableListView(
                    scrollController: _scrollControllerReorderableList,
                    scrollDirection: Axis.horizontal,
                    onReorder: widget.controller._reorderTiles,
                    children: ttiles,
                  )),
            ),
            widget.underBarBuilder == null
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _scrollControllerNamingLine,
                        itemBuilder: widget.underBarBuilder!,
                        separatorBuilder: (_, __) => SizedBox(
                          height: 10,
                          width: MediaQuery.of(context).size.width /
                              widget.totalSteps,
                        ),
                        itemCount:
                            lus < widget.totalSteps ? widget.totalSteps : lus,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  )
          ],
        ));
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

  int totalLengthUnits() {
    final lastTile = value.tiles.lastOrNull;
    if (lastTile == null) {
      return 0;
    }
    return lastTile.startPosition! + lastTile.length!;
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

  void removeTile(int index) {
    value.tiles.removeAt(index);

    // update index for all higher ups
    for (int i = index; i > value.tiles.length; i++) {
      value.tiles[i].index = i;
    }
  }

  void _reorderTiles(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final temp = value.tiles.removeAt(oldIndex);
    value.tiles.insert(newIndex, temp);

    notifyListeners();
  }
}
