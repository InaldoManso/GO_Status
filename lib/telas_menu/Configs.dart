import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/model/ConfigUser.dart';

class Configs extends StatefulWidget {
  @override
  _ConfigsState createState() => _ConfigsState();
}

class _ConfigsState extends State<Configs> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ConfigUser configUser = ConfigUser();
  Paleta paleta = Paleta();
  User user;

  //Atributos
  bool _exibirclassificacao = false;
  bool _carregado = false;

  _atualizarConfig() {
    configUser.exibirclass = _exibirclassificacao;
    db.collection("usuarios").doc(user.uid).update(configUser.toMap());
  }

  _recuperarConfig(String uid) async {
    DocumentSnapshot snapshot = await db.collection("usuarios").doc(uid).get();

    configUser.exibirclass = snapshot["exibirclass"];
    _exibirclassificacao = configUser.exibirclass == false ? false : true;
    _carregado = true;

    setState(() {});
  }

  _deslogarUser() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGOUT_ROTA);
    });
  }

  _recuperarDadosUser() async {
    user = await auth.currentUser;
    _recuperarConfig(user.uid);
  }

  @override
  void initState() {
    _recuperarDadosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 40, bottom: 70),
          child: configuracoesCarregadas()),
    );
  }

  Widget configuracoesCarregadas() {
    Widget widget = Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(child: CircularProgressIndicator()),
    );

    if (_carregado) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Configurações",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ),
          Divider(),
          SwitchListTile(
              title: Text("Exibir seu KD na classificação global"),
              value: _exibirclassificacao,
              onChanged: (bool valor) {
                setState(() {
                  _exibirclassificacao = valor;
                  _atualizarConfig();
                });
              }),
          Divider(),
          Center(
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width / 3,
                decoration: BoxDecoration(
                    color: paleta.royalBlue,
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Logof",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.power_settings_new_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              onTap: () {
                _deslogarUser();
              },
            ),
          )
        ],
      );
    }

    return widget;
  }
}
