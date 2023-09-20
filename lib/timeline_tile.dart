import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:timeline_editor/timeline.dart';

class TimelineTile extends StatefulWidget {
  final TimedTile tileData;
  final double scaling;
  const TimelineTile(
      {super.key, required this.tileData, required this.scaling});

  @override
  State<TimelineTile> createState() => _TimelineTileState();
}

class _TimelineTileState extends State<TimelineTile> {
  @override
  Widget build(BuildContext context) {
    assert(widget.tileData.length != null);
    assert(widget.tileData.startPosition != null);
    assert(widget.tileData.index != null);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.amber,
        width: widget.scaling * widget.tileData.length!,
        child: widget.tileData.child,
      ),
    );
  }
}
