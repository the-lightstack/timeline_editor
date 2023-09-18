import 'package:flutter/widgets.dart';

/// A class that describes the timeline with all its [TimedTile] child nodes.
/// Has Entity suffix to not be confused with dart built-in Widget
class TimelineEntity {
  @override
  String toString() => throw UnimplementedError();
}

/// Describes one entity that can be later dragged around in an [EditableTimeline]
class TimedTile {
  Widget child;
  int startPosition;
  int length;
  TimedTile(
      {required this.child, required this.startPosition, required this.length});
}
