import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/CustomSearchDelegate.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/telas_menu/Alertas.dart';
import 'package:go_status/telas_menu/Cassificacao.dart';
import 'package:go_status/telas_menu/Configs.dart';
import 'package:go_status/telas_menu/Grupos.dart';
import 'package:go_status/telas_menu/Inicio.dart';
import 'package:go_status/telas_menu/Perfil.dart';
import 'package:go_status/telas_menu/ReportBug.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //atributos

  //Atributos das telas
  int _indiceAtual = 0;
  String _resultado = "";

  _deslogarUser() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGOUT_ROTA);
    });
  }

  _apresentarTela(int indice) {
    setState(() {
      _indiceAtual = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Telas apresentadas
    List<Widget> telas = [
      Inicio(_resultado), //0
      Alertas(), //1
      Perfil(), //2
      Cassificacao(), //3
      Grupos(), //4
      Configs(), //5
      ReportBug() //6
    ];

    return Scaffold(
      extendBody: true,
      body: Container(
        child: telas[_indiceAtual],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 30,
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
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            _apresentarTela(0);
            String res = await showSearch(
                context: context, delegate: CustomSearchDelegate());
            setState(() {
              _resultado = res;
            });
          },
        ),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {
              _apresentarTela(1);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              _apresentarTela(2);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.list_alt_outlined),
            onPressed: () {
              _apresentarTela(3);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.people_alt_outlined),
            onPressed: () {
              _apresentarTela(4);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              _apresentarTela(5);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.bug_report_outlined),
            onPressed: () {
              _apresentarTela(6);
            }),
      ),
      Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            icon: Icon(Icons.power_settings_new_outlined),
            onPressed: () {
              _deslogarUser();
            }),
      ),
    ]);
    return row;
  }
}
