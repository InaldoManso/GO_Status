import 'package:go_status/core/data/network/api_stats.dart';
import 'package:go_status/features/profile/presentation/profile.dart';
import 'package:go_status/features/timeline/presentation/post_timeline.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/features/classification/presentation/classification.dart';
import 'package:go_status/features/group_message/presentation/general_chat.dart';
import 'package:go_status/features/comparison/presentation/compare_gun.dart';
import 'package:go_status/features/settings/presentation/settings.dart';
import 'package:go_status/features/groups/presentation/groups.dart';
import 'package:go_status/features/video/presentation/videos.dart';
import 'package:go_status/features/maps/presentation/maps.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //atributos
  ColorPallete paleta = ColorPallete();
  ApiStats apiStats = ApiStats();

  //Atributos das telas
  int _indiceAtual = 0;
  String _resultado = "";

  _apresentarTela(int indice) {
    setState(() {
      _indiceAtual = indice;
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
      Profile(), //1
      Classification(), //2
      Videos(_resultado), //3
      GeneralChat(), //4
      CompareGun(), //5
      Maps(), //6
      Groups(), //7
      Settings(), //8
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
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
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
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
            onPressed: () {
              _apresentarTela(1);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(
              Icons.list_alt_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _apresentarTela(2);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(
              Icons.video_library_outlined,
              color: Colors.white,
            ),
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
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(
              Icons.chat_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _apresentarTela(4);
            }),
      ),
      // Container(
      //   margin: EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //       color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
      //   child: IconButton(
      //     icon: Icon(
      //       Icons.compare_arrows_outlined,
      //       color: Colors.white,
      //     ),
      //     onPressed: () {
      //       _apresentarTela(5);
      //     },
      //   ),
      // ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          icon: Icon(
            Icons.map_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            _apresentarTela(6);
          },
        ),
      ),
      // Container(
      //   margin: EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //       color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
      //   child: IconButton(
      //       icon: Icon(
      //         Icons.people_alt_outlined,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         _apresentarTela(7);
      //       }),
      // ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.dodgerBlue, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _apresentarTela(8);
            }),
      ),
    ]);
    return row;
  }
}
