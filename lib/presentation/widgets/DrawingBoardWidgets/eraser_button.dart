import 'package:flutter/material.dart';
import 'package:patternpulse/config/theme.dart';
import 'package:scribble/scribble.dart';
import 'package:value_notifier_tools/value_notifier_tools.dart';

Widget eraserButton(BuildContext context, ScribbleNotifier notifier) {
  return ValueListenableBuilder(
    valueListenable: notifier.select((value) => value is Erasing),
    builder: (context, value, child) => IconButton(
      color: darkBlue300 ,
      iconSize: 40,
      onPressed: () => notifier.setEraser(),
      icon: Icon(value
          ? Icons.do_not_disturb_on_rounded
          : Icons.do_not_disturb_on_outlined),
    ),
  );
}
