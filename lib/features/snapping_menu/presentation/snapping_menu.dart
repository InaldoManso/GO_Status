import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:flutter/material.dart';

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
                              child: CircleAvatar(
                                child: _image == ""
                                    ? CircularProgressIndicator()
                                    : ClipOval(child: Image.network(_image)),
                                radius: 35,
                                backgroundColor: Colors.grey,
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 70,
                                color: Colors.green,
                              ),
                              Container(
                                height: 70,
                                color: Colors.yellow,
                              ),
                              Container(
                                height: 70,
                                color: Colors.green,
                              ),
                              Container(
                                height: 70,
                                color: Colors.yellow,
                              ),
                              Container(
                                height: 70,
                                color: Colors.green,
                              ),
                              Container(
                                height: 70,
                                color: Colors.yellow,
                              ),
                              Container(
                                height: 70,
                                color: Colors.green,
                              ),
                              Container(
                                height: 70,
                                color: Colors.yellow,
                              ),
                              Container(
                                height: 70,
                                color: Colors.green,
                              ),
                              Container(
                                height: 70,
                                color: Colors.yellow,
                              ),
                              Container(
                                height: 70,
                                color: Colors.green,
                              ),
                              Container(
                                height: 70,
                                color: Colors.yellow,
                              ),
                            ],
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
