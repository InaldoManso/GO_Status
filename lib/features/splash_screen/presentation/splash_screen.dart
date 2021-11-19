import 'package:go_status/core/data/network/api_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_status/core/tools/route_generator.dart';
import 'package:go_status/core/tools/version_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/core/model/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/core/model/user_stats.dart';
import 'package:go_status/core/data/network/api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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

  _checkApiKeys() async {
    DocumentSnapshot snapshot = await db
        .collection("admgostatus")
        .doc("credentials")
        .get()
        .then((snapshotValue) {
      steamapikey = snapshotValue["steamapikey"];
      youtubeapikey = snapshotValue["youtubeapikey"];

      _checkLogin();
    }).catchError((onError) {
      print("teste001 Splash ERR: Erro ao recuperar API Keys");
      _snackBarInfo(
          "Erro ao se comunicar com o servidor,\nentre em contato com seu Saver");
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("steamapikey", steamapikey).then((value) {});
    await prefs.setString("youtubeapikey", youtubeapikey).then((value) {});
  }

  _checkLogin() {
    print("teste001 Splash INF: Verificando Login User");
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    if (user != null) {
      print("teste001 Splash INF: User esta logado no app");
      _recoverUserData();
    } else {
      print("teste001 Splash INF: User NÃO esta logado");
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, RouteGenerator.loginRoute);
      });
    }
  }

  _recoverUserData() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    String steamid = snapshot["steamid"];

    usuario = await api.recDataUserFromSteamID(steamapikey, steamid);

    if (usuario != null) {
      _recoverStatsUserToUpdate(steamid, usuario.name, usuario.urlimage);
      setState(() {
        _carregando = true;
      });
    } else {
      _snackBarInfo(
          "Erro ao se conectar com a Steam, tente novamente mais tarde!");
    }
  }

  _recoverStatsUserToUpdate(
      String steamid, String nome, String urlimage) async {
    ApiStats apiStats = ApiStats();
    csgoStats = await apiStats.updateUserStats(steamid);
    print("teste001 Splash SUC: Stats user KD: " + csgoStats.killdeath);

    if (csgoStats != null) {
      print("teste001 Splash INF: Enviando atualização para o DB");
      User user = auth.currentUser;
      db
          .collection("users")
          .doc(user.uid)
          .update(csgoStats.toMap())
          .then((value) {
        setState(() {
          _carregando = false;
        });
        _validateRegistrationVersion();
      });
    } else {
      print("teste001 Splash ERR: api steamStts não retornou valor");
      _snackBarInfo(
          "Erro ao se conectar com a Steam, tente novamente mais tarde!");
      setState(() {
        _carregando = false;
      });
    }
  }

  _validateRegistrationVersion() async {
    print("teste001 Splash INF: Validando versão do cadastro");
    VersionControl versionControl = VersionControl();
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    String version = snapshot["version"];
    print("teste: 03 version" + version);
    bool updated = await versionControl.versionCheck(version, user.uid);
    if (updated == true) {
      print("teste001 Splash SUC: Cadastro ESTA atualizado");
      Navigator.pushReplacementNamed(context, RouteGenerator.homeRoute);
    } else {
      print("teste001 Splash ERR: Cadastro NÃO ESTA atualizado");
      _validateRegistrationVersion();
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
    _checkApiKeys();
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
