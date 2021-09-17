import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/model/CsgoStats.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/Api.dart';
import 'package:flutter/material.dart';
import 'package:go_status/model/Usuario.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Atributos
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Paleta paleta = Paleta();
  Api api = Api();
  bool _carregando = false;

  //Dados a atualizar do User
  CsgoStats csgoStats = CsgoStats();
  Usuario usuario = Usuario();
  String steamapikey;
  String youtubeapikey;

  Future _verificarLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    if (user != null) {
      _recuperarAdmKeys();
    } else {
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROTA);
      });
    }
  }

  _recuperarAdmKeys() async {
    DocumentSnapshot snapshot = await db
        .collection("admgostatus")
        .doc("credenciais")
        .get()
        .then((snapshot) async {
      steamapikey = snapshot["steamapikey"];
      print("Resultado: 1 " + steamapikey);
      youtubeapikey = snapshot["youtubeapikey"];
      print("Resultado: 2 " + youtubeapikey);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("steamapikey", steamapikey);
      await prefs.setString("youtubeapikey", youtubeapikey);

      _recuperarDadosUser();
    }).catchError((onError) {
      _snackBarInfo("Resultado: Erro ao recuperar seus dados");
    });
  }

  _recuperarDadosUser() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    String steamid = snapshot["steamid"];

    usuario = await api.resgatarDadosSteamID(steamapikey, steamid);

    // _recSteamID(steamid);
    if (usuario != null) {
      _recuperarCsgoStats(steamid, usuario.nome, usuario.urlimage);
      setState(() {
        _carregando = true;
      });
    } else {
      _snackBarInfo("Resultado: Erro ao recuperar seus dados");
    }
  }

  _recuperarCsgoStats(String steamid, String nome, String urlimage) async {
    csgoStats =
        await api.atualizarStatsCsgo(steamapikey, steamid, nome, urlimage);

    if (csgoStats != null) {
      print("Resultado: Sucesso PORRA");

      User user = auth.currentUser;

      db
          .collection("usuarios")
          .doc(user.uid)
          .update(csgoStats.toMap())
          .then((value) {
        setState(() {
          _carregando = false;
        });
        Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROTA);
      });
    } else {
      _snackBarInfo("Resultado: Erro ao recuperar seus dados");
      setState(() {
        _carregando = false;
      });
    }
  }

  void _snackBarInfo(String campoVazio) {
    final snackBar = SnackBar(
      backgroundColor: Colors.blue,
      content:
          Text(campoVazio, style: TextStyle(fontSize: 16, color: Colors.white)),
      action: SnackBarAction(
          label: "OK", textColor: Colors.white, onPressed: () {}),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _verificarLogado();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "GO ",
                    style: TextStyle(
                        color: paleta.orange,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Status",
                    style: TextStyle(
                        color: paleta.royalBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
              height: 60,
              child: Center(
                child: _carregando ? CircularProgressIndicator() : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
