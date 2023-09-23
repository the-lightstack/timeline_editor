# Timeline Editor
An editable Timeline for Flutter. Can be used whenever

## Features

- Adding/Removing tiles
- Reordering tiles via dragging
- Resizing tiles
- Choose from view-only & editable timeline
- Custom steps on bar below timeline


## Getting started

Add the package to your `pubspec.yaml`

## Usage


Creating the most basic editable timeline.
```dart

class _MainAppState extends State<MainApp> {
  final EditableTimelineController _controller =
      EditableTimelineController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () => _controller.addTile(TimedTile(
                  child: Center(child:Text("Tile")),
                ))),
        body: Center(
          child: EditableTimeline(
            controller: _controller
          ),
        ),
      ),
    );
  }
}

```
