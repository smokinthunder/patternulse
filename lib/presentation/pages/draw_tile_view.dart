import 'package:flutter/material.dart';
import 'package:patternpulse/config/theme.dart';
import 'package:patternpulse/presentation/pages/drawing_board_view.dart';
import 'package:patternpulse/routes/draw_route.dart';
import 'package:provider/provider.dart';

class DrawTile extends StatelessWidget {
  const DrawTile({super.key});

  static const List<String> words = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Draw Tile",
            style: greetingTextStyle.copyWith(color: Colors.white)),
        backgroundColor: darkBlue500,
      ),
      // body: ListView.builder(
      //   itemCount: words.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(words[index]),
      //       onTap: () {
      //         context.read<DrawRouteProvider>().updateDrawRouteDisplay(
      //               DrawingBoard(
      //                 expectedWord: words[index],
      //               ),
      //             );
      //       },
      //     );
      //   },
      // ),

      body: GridView.builder(
        itemCount: words.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) {
          return GridTile(
            child: Center(
              child: InkWell(
                  onTap: () {
                    context.read<DrawRouteProvider>().updateDrawRouteDisplay(
                          DrawingBoard(
                            expectedWord: words[index],
                          ),
                        );
                  },
                  child: Text(
                    words[index],
                    style: greetingTextStyle,
                  )),
            ),
          );
        },
      ),
    );
  }
}
