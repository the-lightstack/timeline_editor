import 'package:flutter/material.dart';
import 'package:timeline_editor/src/timeline_data.dart';
import 'package:timeline_editor/src/timeline_editor.dart';
import 'package:timeline_editor/src/timeline_style.dart';

class TimelineViewer extends StatefulWidget {
  final List<TimedTile> tiles;
  final int totalSteps;
  final Widget? Function(BuildContext, int)? underBarBuilder;
  final TimelineEditorStyle? style;
  final List<PopupMenuEntry> Function(int index)? popupMenuItemsBuilder;
  final Function(int index)? directDoubleClickAction;

  const TimelineViewer(
      {super.key,
      required this.tiles,
      this.totalSteps = 20,
      this.underBarBuilder,
      this.style,
      this.popupMenuItemsBuilder,
      this.directDoubleClickAction})
      : assert(
            !(popupMenuItemsBuilder != null && directDoubleClickAction != null),
            "Choose one. Either have direct action on double click or show context menu with multiple actions");

  @override
  State<TimelineViewer> createState() => _TimelineViewerState();
}

class _TimelineViewerState extends State<TimelineViewer> {
  late EditableTimelineController _controller;
  late ScrollController _scrollControllerTileList;
  late ScrollController _scrollControllerNamingLine;

  void _renderScreen() {
    setState(() {});
  }

  @override
  void initState() {
    _controller = EditableTimelineController();
    _controller.restoreAllTiles(widget.tiles);

    _scrollControllerNamingLine = ScrollController();
    _scrollControllerTileList = ScrollController();

    _controller.addListener(_renderScreen);

    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_renderScreen);
    _scrollControllerNamingLine.dispose();
    _scrollControllerTileList.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TimelineViewer oldWidget) {
    _controller.restoreAllTiles(widget.tiles);
    _renderScreen();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> ttiles = <Widget>[
      for (int i = 0; i < widget.tiles.length; i++)
        Padding(
          padding: widget.style?.tilePadding ?? const EdgeInsets.all(4.0),
          child: GestureDetector(
            onDoubleTapDown: (details) {
              if (widget.directDoubleClickAction != null) {
                widget.directDoubleClickAction!(i);
              } else if (widget.popupMenuItemsBuilder != null) {
                final double wsdy =
                    details.globalPosition.dy - details.localPosition.dy;
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(details.globalPosition.dx,
                        wsdy, details.globalPosition.dx, wsdy),
                    items: widget.popupMenuItemsBuilder!(i));
              }
            },
            child: SizedBox(
              width: (MediaQuery.of(context).size.width / widget.totalSteps) *
                  widget.tiles[i].length!,
              child: widget.tiles[i].child,
            ),
          ),
        )
    ];
    final int lus = _controller.totalLengthUnits();
    return SizedBox(
        height: widget.style?.timelineAndBarHeight ?? 100,
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: Container(
                decoration: widget.style?.timelineDecoration,
                child: NotificationListener(
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification) {
                      _scrollControllerNamingLine
                          .jumpTo(_scrollControllerTileList.offset);
                    }
                    return false;
                  },
                  child: ListView(
                    controller: _scrollControllerTileList,
                    scrollDirection: Axis.horizontal,
                    children: ttiles,
                  ),
                ),
              ),
            ),
            widget.underBarBuilder == null
                ? const SizedBox.shrink()
                : SizedBox(
                    height: 30,
                    child: Container(
                      decoration: widget.style?.numberlineDecoration,
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
                          itemCount: ((lus < widget.totalSteps
                                  ? widget.totalSteps
                                  : lus)
                                ..toInt()) +
                              (_controller.defaultTileLength * 2),
                          scrollDirection: Axis.horizontal,
                        ),
                      ),
                    ),
                  )
          ],
        ));
  }
}
