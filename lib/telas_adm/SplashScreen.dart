import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/model/CsgoStats.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/Api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //Atributos
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  CsgoStats csgoStats = CsgoStats();
  Paleta paleta = Paleta();
  Api api = Api();
  bool _carregando = false;

  Future _verificarLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    if (user != null) {
      recDadosUser();
    } else {
      Future.delayed(Duration(milliseconds: 2000), () {
        Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROTA);
      });
    }
  }

  recDadosUser() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    String steamid = snapshot["steamid"];

    _recSteamID(steamid);
    setState(() {
      _carregando = true;
    });
  }

  _recSteamID(String steamID) async {
    http.Response response = await http.get(api.recSteamID + steamID);

    //Decodificar o resultado (String to Json)
    Map<String, dynamic> retorno = json.decode(response.body);

    csgoStats.urlimage =
        retorno["response"]["players"][0]["avatarfull"].toString();
    csgoStats.nome =
        retorno["response"]["players"][0]["personaname"].toString();

    _recCsgoStats(steamID);
  }

  _recCsgoStats(String steamID) async {
    http.Response response =
        // ignore: missing_return
        await http.get(api.recCSGO1 + steamID + api.recCSGO2);

    print("XXX " + response.statusCode.toString());

    if (response.statusCode == 200) {
      print("XXX Sucesso PORRA");
      //Decodificar o resultado (String to Json)
      Map<String, dynamic> retorno = json.decode(response.body);

      //Total Kill
      Map<String, dynamic> kills = retorno["playerstats"]["stats"][0];
      csgoStats.kill = kills["value"].toString();

      //Total Deaths
      Map<String, dynamic> deaths = retorno["playerstats"]["stats"][1];
      csgoStats.death = deaths["value"].toString();

      //Total Time
      Map<String, dynamic> time = retorno["playerstats"]["stats"][2];
      csgoStats.timeplay = time["value"].toString();

      //Total Wins
      Map<String, dynamic> wins = retorno["playerstats"]["stats"][5];
      csgoStats.wins = wins["value"].toString();

      //Total MVPs
      Map<String, dynamic> mvps = retorno["playerstats"]["stats"][98];
      csgoStats.mvps = mvps["value"].toString();

      //Total HShots
      Map<String, dynamic> hshots = retorno["playerstats"]["stats"][25];
      csgoStats.headshots = hshots["value"].toString();

      int kil = int.parse(csgoStats.kill);
      int dth = int.parse(csgoStats.death);
      double KD = kil / dth;

      csgoStats.resultkd = KD.toStringAsPrecision(2);
      print("XXX " + csgoStats.toMap().toString());

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
      _snackBarInfo("Erro ao recuperar seus dados");
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
