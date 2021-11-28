import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:go_status/core/tools/route_generator.dart';
import 'package:go_status/features/snapping_menu/model/snapping_item.dart';
import 'package:go_status/features/snapping_menu/tools/snapping_selector.dart';

class SnappingMenu extends StatefulWidget {
  // const SnappingMenu({ Key? key }) : super(key: key);

  @override
  _SnappingMenuState createState() => _SnappingMenuState();
}

class _SnappingMenuState extends State<SnappingMenu> {
  //Classes and Packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ColorPallete colorPallete = ColorPallete();

//Atributos User
  String _name = "";
  String _image = "";
  String _country = "";

  _recoverUserData() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    setState(() {
      _name = snapshot["name"];
      _image = snapshot["urlimage"];
      _country = snapshot["country"];
    });
  }

  Future<List<SnappingItem>> _recoverMenuItems() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("interface")
        .doc("menuItems")
        .collection("items")
        .orderBy("order", descending: false)
        .get();

    List<SnappingItem> menulist = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var data = item.data();
      if (data["enabled"] == false || data["type"] != "menuButton") continue;

      SnappingItem snappingItem = SnappingItem();
      snappingItem.enabled = data["enabled"];
      snappingItem.id = data["id"];
      snappingItem.order = data["order"];
      snappingItem.tittle = data["tittle"];
      snappingItem.type = data["type"];

      menulist.add(snappingItem);
    }

    return menulist;
  }

  @override
  void initState() {
    _recoverUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(30, 30, 0, 30),
              color: Colors.transparent,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.fromLTRB(40, 10, 0, 50),
                  decoration: BoxDecoration(
                    color: colorPallete.dodgerBlue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(130),
                      bottomLeft: Radius.circular(130),
                    ),
                  ),
                  // >==== Column of interface ====<
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: Text(
                                      _name,
                                      overflow: TextOverflow.fade,
                                      textAlign: TextAlign.left,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _country,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.left,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: colorPallete.orange),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: CircleAvatar(
                                  child: _image == ""
                                      ? CircularProgressIndicator()
                                      : ClipOval(child: Image.network(_image)),
                                  radius: 35,
                                  backgroundColor: Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RouteGenerator.snappingScreenShow,
                                      arguments: "profile");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Divider(color: Colors.white),
                      ),
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: FutureBuilder<List<SnappingItem>>(
                            future: _recoverMenuItems(),
                            // ignore: missing_return
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                  break;
                                case ConnectionState.active:
                                case ConnectionState.done:
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      List<SnappingItem> snappingItemsList =
                                          snapshot.data;
                                      SnappingItem snappingItem =
                                          snappingItemsList[index];

                                      return Container(
                                        padding: EdgeInsets.all(8),
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            primary: Colors.white,
                                            padding: const EdgeInsets.all(15),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                          ),
                                          icon: Icon(
                                              Icons.video_collection_outlined,
                                              color: colorPallete.dodgerBlue),
                                          label: Text(
                                            snappingItem.tittle,
                                            style: TextStyle(
                                                color: colorPallete.dodgerBlue),
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                              context,
                                              RouteGenerator.snappingScreenShow,
                                              arguments: snappingItem.id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                  break;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
