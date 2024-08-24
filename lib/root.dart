import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:patternpulse/config/theme.dart';
import 'package:patternpulse/presentation/pages/draw_tile_view.dart';
import 'package:patternpulse/presentation/pages/upload_page_view.dart';
import 'package:patternpulse/routes/draw_route.dart';
import 'package:patternpulse/routes/upload_route.dart';
import 'package:provider/provider.dart';

class RootView extends StatefulWidget {
  final int currentScreen;

  const RootView({super.key, required this.currentScreen});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int _currentIndex = 0;
  final screens = [const DrawRoute(), const UploadRoute()];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentScreen;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool B) => _onBackPressed(),
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: backgroundColor,
              statusBarIconBrightness: Brightness.dark),
        ),
        backgroundColor: backgroundColor,
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: CustomBottomNavBar(
          defaultSelectedIndex: _currentIndex,
          selectedItemIcon: const [
            CupertinoIcons.hand_draw_fill,
            CupertinoIcons.cloud_upload_fill,
          ],
          unselectedItemIcon: const [
            CupertinoIcons.hand_draw,
            CupertinoIcons.cloud_upload,
          ],
          label: const [
            "Draw",
            "Upload",
          ],
          onChange: (val) {
            setState(() {
              _currentIndex = val;
            });
          },
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit the App'),
            content: const Text('Do you want to exit the application?'),
            actions: <Widget>[
              // const SizedBox(height: 16),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No')),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class CustomBottomNavBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final List<IconData> selectedItemIcon;
  final List<IconData> unselectedItemIcon;
  final List<String> label;
  final Function(int) onChange;

  const CustomBottomNavBar(
      {super.key,
      this.defaultSelectedIndex = 0,
      required this.selectedItemIcon,
      required this.unselectedItemIcon,
      required this.label,
      required this.onChange});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;
  List<IconData> _selectedItemIcon = [];
  List<IconData> _unselectedItemIcon = [];
  List<String> _label = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex;
    _selectedItemIcon = widget.selectedItemIcon;
    _unselectedItemIcon = widget.unselectedItemIcon;
    _label = widget.label;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> navBarItems = [];

    for (int i = 0; i < 2; i++) {
      navBarItems.add(bottomNavBarItem(
          _selectedItemIcon[i], _unselectedItemIcon[i], _label[i], i));
    }
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: navBarItems,
      ),
    );
  }

  Widget bottomNavBarItem(activeIcon, inactiveIcon, label, index) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        if (_selectedIndex == index) {
          if (index == 0) {
            context
                .read<DrawRouteProvider>()
                .updateDrawRouteDisplay(const DrawTile());
          } else {
            context
                .read<UploadRouteProvider>()
                .updateUploadRouteDisplay( const UploadPageView());
          }
        }
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: kBottomNavigationBarHeight,
        width: MediaQuery.of(context).size.width / _selectedItemIcon.length,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _selectedIndex == index
              ? Container(
                  decoration: BoxDecoration(
                      color: lightBlue400, 
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        activeIcon,
                        size: 22,
                        color: darkBlue300,
                      ),
                      Text(label, style: bottomNavTextStyle),
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      inactiveIcon,
                      size: 22,
                      color: primaryColor300,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
