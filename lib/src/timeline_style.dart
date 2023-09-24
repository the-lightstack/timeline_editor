import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimelineEditorStyle {
  EdgeInsets? tilePadding;
  BoxDecoration? timelineDecoration;
  BoxDecoration? numberlineDecoration;
  double? timelineAndBarHeight;
  TimelineEditorStyle(
      {this.numberlineDecoration,
      this.timelineDecoration,
      this.tilePadding,
      this.timelineAndBarHeight});
}
