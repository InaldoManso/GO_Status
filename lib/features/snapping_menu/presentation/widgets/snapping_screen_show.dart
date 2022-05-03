import 'package:flutter/material.dart';
import 'package:go_status/features/snapping_menu/tools/snapping_selector.dart';

class SnappingScreenShow extends StatefulWidget {
  final dynamic screen;
  const SnappingScreenShow(this.screen);

  @override
  _SnappingScreenShowState createState() => _SnappingScreenShowState();
}

class _SnappingScreenShowState extends State<SnappingScreenShow> {
  //Classes and Packages
  SnappingSelector snappingSelector = SnappingSelector();
  //Attributes
  Widget _screenWidget = Container();

  _initScreen() {
    print(widget.screen);
    setState(() {
      _screenWidget = snappingSelector.menuScreens(widget.screen);
    });
  }

  @override
  void initState() {
    _initScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenWidget,
    );
  }
}
