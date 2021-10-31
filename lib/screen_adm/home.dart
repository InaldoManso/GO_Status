import 'package:flutter/material.dart';
import 'package:go_status/helper/color_pallete.dart';
import 'package:go_status/screen_menu/compare_gun.dart';
import 'package:go_status/screen_menu/videos.dart';
import 'package:go_status/screen_menu/report.dart';
import 'package:go_status/screen_menu/profile.dart';
import 'package:go_status/screen_menu/timeline.dart';
import 'package:go_status/screen_menu/classification.dart';
import 'package:go_status/screen_menu/general_chat.dart';
import 'package:go_status/screen_menu/groups.dart';
import 'package:go_status/screen_menu/maps.dart';
import 'package:go_status/screen_menu/settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //atributos
  ColorPallete paleta = ColorPallete();

  //Atributos das telas
  int _indiceAtual = 0;
  String _resultado = "";

  _apresentarTela(int indice) {
    setState(() {
      _indiceAtual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Telas apresentadas
    List<Widget> telas = [
      TimeLine(), //0
      Profile(), //1
      Classification(), //2
      Videos(_resultado), //3
      GeneralChat(), //4
      CompareGun(), //5
      Maps(), //6
      Groups(), //7
      Report(), //8
      Settings(), //9
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        child: telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.all(4),
          child: _rowMenu(),
        ),
      ),
    );
  }

  Row _rowMenu() {
    Widget row = Row();

    row = Row(children: [
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.home_outlined),
            onPressed: () {
              _apresentarTela(0);
              setState(() {
                _resultado = "";
              });
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              _apresentarTela(1);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.list_alt_outlined),
            onPressed: () {
              _apresentarTela(2);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.video_library_outlined),
            onPressed: () {
              _apresentarTela(3);
              setState(() {
                _resultado = "";
              });
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.chat_outlined),
            onPressed: () {
              _apresentarTela(4);
            }),
      ),
      /*Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          icon: Icon(Icons.compare_arrows_outlined),
          onPressed: () {
            _apresentarTela(5);
          },
        ),
      ),*/
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          icon: Icon(Icons.map_outlined),
          onPressed: () {
            _apresentarTela(6);
          },
        ),
      ),
      /*Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.people_alt_outlined),
            onPressed: () {
              _apresentarTela(7);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.bug_report_outlined),
            onPressed: () {
              _apresentarTela(8);
            }),
      ),*/
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              _apresentarTela(9);
            }),
      ),
    ]);
    return row;
  }
}
