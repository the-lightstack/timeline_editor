import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timeline_editor/timeline.dart';
import 'package:timeline_editor/timeline_editor.dart';

void main() {
  test("timeline controller compute startPos", () {
    final controller = EditableTimelineController();
    controller.addTile(TimedTile(child: const Text("1")));
    controller.addTile(TimedTile(child: const Text("2")));
    controller.addTile(TimedTile(child: const Text("3")));

    expect(controller.computeStartPosition(2), 10);
  });
}
