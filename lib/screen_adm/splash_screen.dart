import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/helper/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/helper/version_control.dart';
import 'package:go_status/model/user_stats.dart';
import 'package:go_status/helper/color_pallete.dart';
import 'package:go_status/helper/api.dart';
import 'package:flutter/material.dart';
import 'package:go_status/model/user_profile.dart';
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
  ColorPallete paleta = ColorPallete();
  Api api = Api();
  bool _carregando = false;

  //Dados a atualizar do User
  UserStats csgoStats = UserStats();
  UserProfile usuario = UserProfile();
  String steamapikey;
  String youtubeapikey;

  Future _verificarLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    if (user != null) {
      _recuperarAdmKeys();
    } else {
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pushReplacementNamed(context, RouteGenerator.loginRoute);
      });
    }
  }

  _recuperarAdmKeys() async {
    DocumentSnapshot snapshot = await db
        .collection("admgostatus")
        .doc("credentials")
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
        await db.collection("users").doc(user.uid).get();

    String steamid = snapshot["steamid"];

    usuario = await api.recDataUserFromSteamID(steamapikey, steamid);

    // _recSteamID(steamid);
    if (usuario != null) {
      _recuperarCsgoStats(steamid, usuario.name, usuario.urlimage);
      setState(() {
        _carregando = true;
      });
    } else {
      _snackBarInfo("Resultado: Erro ao recuperar seus dados");
    }
  }

  _recuperarCsgoStats(String steamid, String nome, String urlimage) async {
    csgoStats = await api.updateUserStats(steamapikey, steamid, nome, urlimage);

    if (csgoStats != null) {
      User user = auth.currentUser;

      db
          .collection("users")
          .doc(user.uid)
          .update(csgoStats.toMap())
          .then((value) {
        setState(() {
          _carregando = false;
        });
        _validarVersaoCadastral();
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

  _validarVersaoCadastral() async {
    VersionControl versionControl = VersionControl();
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    String version = snapshot["version"];
    bool updated = await versionControl.versionCheck(version, user.uid);
    if (updated == true) {
      Navigator.pushReplacementNamed(context, RouteGenerator.homeRoute);
    } else {
      _validarVersaoCadastral();
    }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
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
                        color: paleta.dodgerBlue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 60,
                child: Center(
                  child:
                      _carregando ? CircularProgressIndicator() : Container(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: paleta.grey900,
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/image/logos/logolmctrsp.png",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            /*Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "distributed by:\n\n",
                    style: TextStyle(
                        color: paleta.orange,
                        fontSize: 8,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Snipers of War",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "distributed by:\n\n",
                    style: TextStyle(
                        color: paleta.grey900,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
