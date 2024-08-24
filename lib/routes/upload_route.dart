import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:patternpulse/presentation/pages/upload_page_view.dart';
import 'package:provider/provider.dart';


class UploadRouteProvider extends ChangeNotifier {
  Widget uploadRouteDisplay;
  UploadRouteProvider({this.uploadRouteDisplay = const UploadPageView()});
  void updateUploadRouteDisplay(Widget newuploadRouteDisplay) async {
    uploadRouteDisplay = newuploadRouteDisplay;
    notifyListeners();
  }
}

class UploadRoute extends StatefulWidget {
  const UploadRoute({super.key});

  @override
  State<UploadRoute> createState() => _UploadRouteState();
}

class _UploadRouteState extends State<UploadRoute> {
  @override
  Widget build(BuildContext context) {
    return context.watch<UploadRouteProvider>().uploadRouteDisplay;
  }
}
