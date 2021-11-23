import 'package:go_status/features/classification/presentation/classification.dart';
import 'package:go_status/features/group_message/presentation/general_chat.dart';
import 'package:go_status/features/timeline/presentation/post_timeline.dart';
import 'package:go_status/features/maps/presentation/maps.dart';
import 'package:go_status/core/data/network/api_stats.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class Home extends StatefulWidget {
  static final snappingSheetController = SnappingSheetController();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Classes and Packages
  ColorPallete colorPallete = ColorPallete();
  ApiStats apiStats = ApiStats();

  //Attributes
  int _currentIndex = 0;
  String _result = "";

  _apresentarTela(int indice) {
    setState(() {
      _currentIndex = indice;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Telas apresentadas
    List<Widget> telas = [
      PostTimeline(), //0
      Classification(), //1
      Maps(), //2
      GeneralChat(), //3
      // Profile(), //1
      // Videos(_result), //3
      // CompareGun(), //5
      // Groups(), //7
      // Settings(), //8
    ];

    return SnappingSheet.horizontal(
      lockOverflowDrag: true,
      controller: Home.snappingSheetController,
      snappingPositions: const [
        SnappingPosition.factor(
          positionFactor: 1.0,
          snappingCurve: Curves.easeOutQuart,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
        SnappingPosition.factor(
          positionFactor: 0.0,
          snappingCurve: Curves.elasticInOut,
          snappingDuration: Duration(milliseconds: 500),
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
      ],
      sheetRight: SnappingSheetContent(
        // sizeBehavior: SheetSizeFill(),
        draggable: true,
        child: Container(
          color: Colors.orange,
        ),
      ),
      child: Scaffold(
        extendBody: true,
        body: Container(
          child: telas[_currentIndex],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 55,
                width: 55,
                margin: EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorPallete.dodgerBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _apresentarTela(0);
                  },
                ),
              ),
              Container(
                height: 55,
                width: 55,
                margin: EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorPallete.dodgerBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Icon(
                    Icons.list_alt_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _apresentarTela(1);
                  },
                ),
              ),
              Container(
                height: 55,
                width: 55,
                margin: EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorPallete.dodgerBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _apresentarTela(2);
                  },
                ),
              ),
              Container(
                height: 55,
                width: 55,
                margin: EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorPallete.dodgerBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Icon(
                    Icons.chat_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _apresentarTela(3);
                  },
                ),
              ),
              Container(
                height: 55,
                width: 55,
                margin: EdgeInsets.all(5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: colorPallete.dodgerBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Icon(
                    Icons.menu_open_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Home.snappingSheetController.snapToPosition(
                      const SnappingPosition.factor(
                        positionFactor: 0.1,
                        snappingCurve: Curves.bounceOut,
                        snappingDuration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
