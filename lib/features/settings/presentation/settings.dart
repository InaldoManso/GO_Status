import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/core/tools/route_generator.dart';
import 'package:go_status/core/model/user_settings.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserSettings configUser = UserSettings();
  ColorPallete paleta = ColorPallete();
  User? user;

  //Atributos
  bool _exibirclassificacao = false;
  bool _recebernotificacoes = false;
  bool _carregado = false;

  _atualizarConfig() {
    configUser.showkilldeath = _exibirclassificacao;
    configUser.sendchatnotify = _recebernotificacoes;
    db.collection("users").doc(user!.uid).update(configUser.toMap());
  }

  _recuperarConfig(String uid) async {
    DocumentSnapshot snapshot = await db.collection("users").doc(uid).get();

    configUser.showkilldeath = snapshot["showkilldeath"];
    configUser.sendchatnotify = snapshot["sendchatnotify"];

    setState(() {
      _exibirclassificacao = configUser.showkilldeath == false ? false : true;
      _recebernotificacoes = configUser.showkilldeath == false ? false : true;
      _carregado = true;
    });
  }

  _deslogarUser() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacementNamed(context, RouteGenerator.logoutRoute);
    });
  }

  _recuperarDadosUser() {
    user = auth.currentUser;
    _recuperarConfig(user!.uid);
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
          SwitchListTile(
              title: Text("Receber notificações do chat Geral"),
              value: _recebernotificacoes,
              onChanged: (bool valor) {
                setState(() {
                  _recebernotificacoes = valor;
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
                    color: paleta.dodgerBlue,
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
