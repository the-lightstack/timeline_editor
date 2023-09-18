library timeline_editor;

import 'package:flutter/widgets.dart';
import 'package:timeline_editor/timeline.dart';

class EditableTimeline extends StatefulWidget {
  const EditableTimeline({super.key});

  @override
  State<EditableTimeline> createState() => _EditableTimelineState();
}

class _EditableTimelineState extends State<EditableTimeline> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class EditableTimelineController extends ValueNotifier<TimelineEntity> {
  EditableTimelineController(super.value);
}
