import 'package:patternpulse/config/theme.dart';
import 'package:patternpulse/presentation/pages/draw_tile_view.dart';
import 'package:patternpulse/presentation/widgets/DrawingBoardWidgets/color_tool_bar.dart';
import 'package:patternpulse/presentation/widgets/DrawingBoardWidgets/save_button.dart';

import 'package:flutter/material.dart';
import 'package:patternpulse/routes/draw_route.dart';
import 'package:provider/provider.dart';
import 'package:scribble/scribble.dart';

class DrawingBoard extends StatefulWidget {
  final String expectedWord;
  const DrawingBoard({super.key, required this.expectedWord});

  @override
  DrawingBoardState createState() => DrawingBoardState();
}

class DrawingBoardState extends State<DrawingBoard> {
  late ScribbleNotifier notifier;

  @override
  void initState() {
    notifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    notifier.setStrokeWidth(2);
    notifier.setAllowedPointersMode(ScribblePointerMode.all);
    return PopScope(
      onPopInvoked: (bool B) {
        context
            .read<DrawRouteProvider>()
            .updateDrawRouteDisplay(const DrawTile());
      },
      canPop: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: darkBlue500,
          leading: IconButton(
            onPressed: () {
              context
                  .read<DrawRouteProvider>()
                  .updateDrawRouteDisplay(const DrawTile());
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            widget.expectedWord,
            style: greetingTextStyle.copyWith(color: Colors.white),
          ),
          actions: _buildActions(context),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              Expanded(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.zero,
                  color: Colors.white,
                  // surfaceTintColor: Colors.white,
                  child: Scribble(
                    
                    notifier: notifier,
                    drawPen: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    colorToolbar(context, notifier),
                    const VerticalDivider(width: 32),
                    saveButton(context, notifier, widget.expectedWord),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActions(context) {
    return [
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => IconButton(
          icon: child as Icon,
          tooltip: "Undo",
          onPressed: notifier.canUndo ? notifier.undo : null,
        ),
        child: const Icon(Icons.undo),
      ),
      ValueListenableBuilder(
        valueListenable: notifier,
        builder: (context, value, child) => IconButton(
          icon: child as Icon,
          tooltip: "Redo",
          onPressed: notifier.canRedo ? notifier.redo : null,
        ),
        child: const Icon(Icons.redo),
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        tooltip: "Clear",
        onPressed: notifier.clear,
      ),
    ];
  }
}
