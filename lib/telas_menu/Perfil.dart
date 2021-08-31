import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Api.dart';
import 'package:go_status/model/CsgoStats.dart';
import 'package:http/http.dart' as http;

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  //Atributos Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Atributos API
  String _steamID;

  //Atributos User
  String _nome = "";
  String _image = "";
  String _pais = "";
  String _steamid = "";

  //Atributos Interface
  Paleta paleta = Paleta();
  Api api = Api();
  Color _corKD;
  String _resultadoKD = "--";
  String _totalKills = "--";
  String _totalDeaths = "--";
  String _totalTime = "--";
  String _totalWins = "--";
  String _totalMvps = "--";
  String _totalHShots = "--";
  double valorkd = 0;
  String label = "0";

  recDadosUser() async {
    _corKD = paleta.royalBlue;
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    setState(() {
      _nome = snapshot["nome"];
      _image = snapshot["urlimage"];
      _pais = snapshot["pais"];
      _steamid = snapshot["steamid"];

      _totalKills = snapshot["kill"];
      _totalDeaths = snapshot["death"];
      _totalTime = snapshot["timeplay"];
      _totalWins = snapshot["wins"];
      _totalMvps = snapshot["mvps"];
      _totalHShots = snapshot["headshots"];
      _resultadoKD = snapshot["resultkd"];
    });

    int gg = int.parse(snapshot["timeplay"]);
    int g1 = 84673;
    var g2 = Duration(minutes: g1);
    print("HORASS " + g2.toString());

    valorkd = double.parse(snapshot["resultkd"]);
    double kdcor = double.parse(snapshot["resultkd"]);
    if (kdcor >= 0.00 && kdcor <= 0.74) {
      setState(() {
        _corKD = Colors.red;
      });
    } else if (kdcor >= 0.75 && kdcor <= 0.99) {
      setState(() {
        _corKD = Colors.orange;
      });
    } else if (kdcor >= 1.00) {
      setState(() {
        _corKD = Colors.green;
      });
    }
  }

  @override
  void initState() {
    recDadosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(8, 100, 8, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  child: _image == ""
                      ? CircularProgressIndicator()
                      : ClipOval(child: Image.network(_image)),
                  radius: 70,
                  backgroundColor: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _nome,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 24, color: paleta.royalBlue),
                        ),
                        Text(
                          _pais,
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 18, color: paleta.royalBlue),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 20, 8, 20),
                child: Divider(
                  color: paleta.royalBlue,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Status geral",
                  style: TextStyle(fontSize: 24, color: paleta.royalBlue),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Kill/ Death",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _resultadoKD,
                      style: TextStyle(fontSize: 18, color: _corKD),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Kills",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _totalKills,
                      style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Total Deaths",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _totalDeaths,
                      style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Horas de jogo",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _totalTime,
                      style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Vitórias",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _totalWins,
                      style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "MVPs",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _totalMvps,
                      style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "HeadShots",
                        style: TextStyle(
                          fontSize: 18,
                          color: paleta.royalBlue,
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.dotted,
                        ),
                      ),
                    ),
                    Text(
                      _totalHShots,
                      style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
