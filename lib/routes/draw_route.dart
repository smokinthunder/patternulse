import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:patternpulse/presentation/pages/draw_tile_view.dart';
import 'package:provider/provider.dart';

class DrawRouteProvider extends ChangeNotifier {
  Widget drawRouteDisplay;
  DrawRouteProvider({this.drawRouteDisplay = const DrawTile()});
  void updateDrawRouteDisplay(Widget newdrawRouteDisplay) async {
    drawRouteDisplay = newdrawRouteDisplay;
    notifyListeners();
  }
}



class DrawRoute extends StatefulWidget {
  const DrawRoute({super.key});

  @override
  State<DrawRoute> createState() => _DrawRouteState();
}

class _DrawRouteState extends State<DrawRoute> {
  @override
  Widget build(BuildContext context) {
    return context.watch<DrawRouteProvider>().drawRouteDisplay;
  }
}
