library timeline_editor;

import 'package:flutter/widgets.dart';
import 'package:timeline_editor/timeline.dart';

class EditableTimeline extends StatefulWidget {
  final EditableTimelineController controller;

  const EditableTimeline({super.key, required this.controller});

  @override
  State<EditableTimeline> createState() => _EditableTimelineState();
}

class _EditableTimelineState extends State<EditableTimeline> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// The developer uses this to interact with the [EditableTimeline] . You can
/// listen to changes as well as add and modify the [TimedTile]s
class EditableTimelineController extends ValueNotifier<TimelineEntity> {
  EditableTimelineController() : super(TimelineEntity());

  List<TimedTile> get tiles => value.tiles;
  void addTile(TimedTile t) {
    value.addTile(t);
  }
}
