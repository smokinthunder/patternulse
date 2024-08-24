import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:patternpulse/config/theme.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

Widget penButton(BuildContext context, ScribbleNotifier notifier) {
  return ValueListenableBuilder(
    valueListenable: notifier.select((value) =>
        value is Drawing && value.selectedColor == Colors.black.value),
    builder: (context, value, child) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        iconSize: 40,
        color: darkBlue300,
        onPressed: () => notifier.setColor(Colors.black),
        icon: Icon(value
            ? CupertinoIcons.pencil_circle_fill
            : CupertinoIcons.pencil_circle),
      ),
    ),
  );
}
