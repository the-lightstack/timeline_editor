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

  test("Total length correct", () {
    final controller = EditableTimelineController();
    controller.addTile(TimedTile(child: const Text("1")));
    controller.addTile(TimedTile(child: const Text("2")));

    expect(controller.tiles.length, 2);
    expect(controller.tiles.last.startPosition, 5);
    expect(controller.totalLengthUnits(), 10);

    controller.changeTileLength(0, 10);
    expect(controller.tiles.length, 2);
    expect(controller.tiles.last.startPosition, 10);
    expect(controller.totalLengthUnits(), 15);

    // Taking the first and dragging it after the second
    controller.reorderTiles(0, 2);
    expect(controller.tiles.last.startPosition, 5);
    expect(controller.totalLengthUnits(), 15);
  });

  test("Right calculations after lots of resizing", () {
    final controller = EditableTimelineController();
    controller.addTile(TimedTile(child: const Text("1")));
    controller.addTile(TimedTile(child: const Text("2")));
    controller.addTile(TimedTile(child: const Text("3")));
    controller.addTile(TimedTile(child: const Text("4")));

    controller.changeTileLength(1, 9);
    controller.changeTileLength(2, 2);
    controller.changeTileLength(3, 12);
    expect(controller.totalLengthUnits(), 28);
  });

  test("Right after removing", () {
    final controller = EditableTimelineController();
    controller.addTile(TimedTile(child: const Text("1")));
    controller.addTile(TimedTile(child: const Text("2")));
    controller.addTile(TimedTile(child: const Text("3")));
    controller.addTile(TimedTile(child: const Text("4")));

    controller.removeTile(1);
    expect(controller.totalLengthUnits(), 15);
    expect(controller.tiles.last.startPosition, 10);

    controller.removeTile(0);
    expect(controller.totalLengthUnits(), 10);
    expect(controller.tiles.last.startPosition, 5);

    controller.removeTile(1);
    expect(controller.totalLengthUnits(), 5);
    expect(controller.tiles.last.startPosition, 0);

    controller.removeTile(0);
    expect(controller.totalLengthUnits(), 0);
  });
}
