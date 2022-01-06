import 'package:go_status/builds/home/aplication/cloud_message.dart';
import 'package:go_status/features/classification/presentation/classification.dart';
import 'package:go_status/features/group_message/presentation/general_chat.dart';
import 'package:go_status/features/snapping_menu/presentation/snapping_menu.dart';
import 'package:go_status/features/timeline/presentation/post_timeline.dart';
import 'package:go_status/features/maps/presentation/maps.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_status/core/data/network/api_stats.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  static final snappingSheetController = SnappingSheetController();
  static final ScrollController scrollController = ScrollController();
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  //Classes and Packages
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  ColorPallete colorPallete = ColorPallete();
  CloudMessage cloudMessage = CloudMessage();
  ApiStats apiStats = ApiStats();

  //Attributes
  late AnimationController controller;
  bool expanded = true;
  int _currentIndex = 0;

  _apresentarTela(int indice) {
    setState(() {
      _currentIndex = indice;
    });
  }

  _initialSettings() async {
    String? fcmToken = await _firebaseMessaging.getToken();
    cloudMessage.saveFCMTokenInFirebase(fcmToken);
  }

  void initState() {
    super.initState();
    _configureFirebaseCloudMessage();
    _initialSettings();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
      reverseDuration: Duration(milliseconds: 400),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Telas apresentadas
    List<Widget> telas = [
      PostTimeline(), //0
      Classification(), //1
      Maps(), //2
      GeneralChat(), //3
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
        childScrollController: Home.scrollController,
        sizeBehavior: SheetSizeFill(),
        draggable: false,
        child: Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height * 0.1,
          ),
          child: SnappingMenu(),
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
          child: Container(
            height: MediaQuery.of(context).size.height * 0.10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black,
                      primary: expanded ? colorPallete.dodgerBlue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (expanded) {
                        _apresentarTela(0);
                      }
                    },
                  ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black,
                      primary: expanded ? colorPallete.dodgerBlue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Icon(
                      Icons.list_alt_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (expanded) {
                        _apresentarTela(1);
                      }
                    },
                  ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black,
                      primary: expanded ? colorPallete.dodgerBlue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Icon(
                      Icons.map_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (expanded) {
                        _apresentarTela(2);
                      }
                    },
                  ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black,
                      primary: expanded ? colorPallete.dodgerBlue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Icon(
                      Icons.chat_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (expanded) {
                        _apresentarTela(3);
                      }
                    },
                  ),
                ),
                Container(
                  height: 55,
                  width: 55,
                  margin: EdgeInsets.all(5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black,
                      primary: colorPallete.dodgerBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: controller,
                      semanticLabel: 'Show menu',
                    ),
                    onPressed: () {
                      if (expanded) {
                        controller.forward();
                        Home.snappingSheetController.snapToPosition(
                          const SnappingPosition.factor(
                            positionFactor: 0.0,
                            snappingCurve: Curves.easeInCubic,
                            snappingDuration: Duration(milliseconds: 500),
                          ),
                        );
                      } else {
                        controller.reverse();
                        Home.snappingSheetController.snapToPosition(
                          const SnappingPosition.factor(
                            positionFactor: 1.0,
                            snappingCurve: Curves.easeInCubic,
                            snappingDuration: Duration(milliseconds: 500),
                          ),
                        );
                      }
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _configureFirebaseCloudMessage() async {
    //Permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);

    //Listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('txtx Got a message whilst in the foreground!');
      print('txtx Message data: ${message.data}');

      print('txtx ' + message.collapseKey.toString());

      if (message.notification != null) {
        print(
            'txtx Message also contained a notification: ${message.notification}');
      }
    });

    //Status
    String? gg = await _firebaseMessaging.getToken();
    print('txtx User granted permission: ${settings.authorizationStatus}');
    print("txtx: " + gg!);
  }
}
