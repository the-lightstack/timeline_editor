import 'package:flutter/material.dart';
import 'package:timeline_editor/timeline.dart';
import 'package:timeline_editor/timeline_editor.dart';

class TimelineTile extends StatefulWidget {
  final TimedTile tileData;
  final int totalSteps;
  final EditableTimelineController controller;
  final int ownIndex;

  const TimelineTile(
      {super.key,
      required this.tileData,
      required this.totalSteps,
      required this.controller,
      required this.ownIndex});

  @override
  State<TimelineTile> createState() => _TimelineTileState();
}

class _TimelineTileState extends State<TimelineTile> {
  bool _isReseized = false;
  late int _displayLength;
  late int _orgLength;
  double? _dragStartX;

  @override
  void initState() {
    assert(widget.tileData.length != null);
    assert(widget.tileData.startPosition != null);
    assert(widget.tileData.index != null);

    _displayLength = widget.tileData.length!;
    _orgLength = widget.tileData.length!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
          width: (MediaQuery.of(context).size.width / widget.totalSteps) *
              _displayLength,
          child: Row(
            children: [
              Flexible(flex: 5, child: widget.tileData.child),
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  assert(_dragStartX != null);
                  final double deltaX = details.localPosition.dx - _dragStartX!;
                  final double stepPixelSize =
                      MediaQuery.of(context).size.width / widget.totalSteps;
                  print(stepPixelSize);

                  final int lengthIncrement =
                      (deltaX / stepPixelSize).truncate();
                  final newDisplayLength = _orgLength + lengthIncrement;
                  if (newDisplayLength >= 1 && newDisplayLength <= 16) {
                    setState(() {
                      _displayLength = newDisplayLength;
                      // _dragStartX = details.localPosition.dx;
                    });
                  }
                },
                onHorizontalDragStart: (details) => setState(() {
                  _dragStartX = details.localPosition.dx;
                  _isReseized = true;
                }),
                onHorizontalDragEnd: (details) {
                  setState(() {
                    _dragStartX = null;
                    _isReseized = false;
                    _orgLength = _displayLength;
                  });
                  widget.controller
                      .changeTileLength(widget.ownIndex, _displayLength);
                },
                child: SizedBox(
                  width: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        color: _isReseized
                            ? const Color.fromARGB(255, 112, 112, 112)
                            : const Color.fromARGB(255, 82, 82, 82),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: const Center(
                        child: Icon(
                      Icons.double_arrow,
                      size: 12,
                    )),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
