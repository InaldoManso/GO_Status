import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/MapDetails.dart';
import 'package:go_status/telas_menu/Cassificacao.dart';
import 'package:go_status/telas_menu/Chat.dart';
import 'package:go_status/telas_menu/Configs.dart';
import 'package:go_status/telas_menu/Grupos.dart';
import 'package:go_status/telas_menu/Inicio.dart';
import 'package:go_status/telas_menu/Maps.dart';
import 'package:go_status/telas_menu/Perfil.dart';
import 'package:go_status/telas_menu/ReportBug.dart';
import 'package:go_status/telas_menu/Videos.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //atributos
  Paleta paleta = Paleta();

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
      Inicio(), //0
      Perfil(), //1
      Cassificacao(), //2
      Videos(_resultado), //1
      Chat(), //4
      Chat(), //5
      Maps(), //6
      Grupos(), //7
      ReportBug(), //8
      Configs(), //9
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
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: paleta.grey850, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          icon: Icon(Icons.compare_arrows_outlined),
          onPressed: () {
            // _apresentarTela(5);
          },
        ),
      ),
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
      Container(
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
      ),
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
