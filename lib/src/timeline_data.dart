import 'package:flutter/widgets.dart';

/// A class that describes the timeline with all its [TimedTile] child nodes.
/// Has Entity suffix to not be confused with dart built-in Widget
class TimelineEntity {
  List<TimedTile> tiles = [];

  TimelineEntity();

  @override
  String toString() => tiles.map((e) => e.toString()).join(",");

  void addTile(TimedTile tile) {
    tiles.add(tile);
  }

  bool removeTile(TimedTile tile) {
    return tiles.remove(tile);
  }
}

/// Describes one entity that can be later dragged around in an [EditableTimeline]
class TimedTile {
  final Widget child;
  int? startPosition;
  int? length;
  int? index;
  Object? data;

  TimedTile({
    required this.child,
    this.data,
  });

  TimedTile.internal(
      {required this.index,
      required this.startPosition,
      required this.length,
      required this.child,
      this.data});

  @override
  String toString() => "{Start: $startPosition | Length: $length}";

  @override
  int get hashCode =>
      Object.hash(startPosition.hashCode, length.hashCode, child.hashCode);

  @override
  bool operator ==(Object other) {
    return (other is TimedTile) &&
        (other.child == child) &&
        (other.length == length) &&
        (other.startPosition == startPosition);
  }
}
