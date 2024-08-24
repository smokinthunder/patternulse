import 'package:flutter/material.dart';
import 'package:patternpulse/presentation/widgets/DrawingBoardWidgets/eraser_button.dart';
import 'package:scribble/scribble.dart';
import 'package:patternpulse/presentation/widgets/DrawingBoardWidgets/pen_button.dart';

Widget colorToolbar(BuildContext context, ScribbleNotifier notifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        penButton(context, notifier),
        // const VerticalDivider(width: 32),
        eraserButton(context, notifier),
      ],
    );
  }