// ignore_for_file: must_be_immutable
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_status/core/tools/route_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/core/model/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/core/model/user_stats.dart';
import 'package:go_status/core/data/network/api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RegistrationUser extends StatefulWidget {
  var userProfile;
  RegistrationUser(this.userProfile);
  @override
  _RegistrationUserState createState() => _RegistrationUserState();
}

class _RegistrationUserState extends State<RegistrationUser> {
  //Classes and Packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ColorPallete paleta = ColorPallete();
  UserProfile userProfile = UserProfile();

  //Attributes
  bool _editando = true;
  String _buttonText = "Criar conta!";
  String? steamapikey;
  String? youtubeapikey;

  //Controllers
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController senhaEditingController = TextEditingController();
  TextEditingController confirmaEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();

  //Validações de métodos
  _processoCadastral() {
    if (_validarCampos()) {
      if (_validarSenha()) {
        //Configurar os dados
        userProfile.name = widget.userProfile!.name;
        userProfile.email = emailEditingController.text;
        userProfile.password = senhaEditingController.text;
        userProfile.steamid = widget.userProfile!.steamid;
        userProfile.team = timeEditingController.text;
        userProfile.urlimage = widget.userProfile!.urlimage;
        userProfile.country = widget.userProfile!.country;
        userProfile.version = "1.0.0";
        _salvarCadastro(userProfile);
      } else {
        _snackBarInfo("Senhas diferentes!");
        senhaEditingController.text = "";
        confirmaEditingController.text = "";
      }
    }
  }

  bool _validarCampos() {
    bool validado = false;

    String a = emailEditingController.text;
    String b = senhaEditingController.text;
    String c = confirmaEditingController.text;

    if (a.isNotEmpty && a.contains("@")) {
      if (b.isNotEmpty && b.length == 6) {
        if (c.isNotEmpty && c.length == 6) {
          validado = true;
          return validado;
        } else {
          _snackBarInfo("Campo Confirmar senha incorreto!");
          return validado;
        }
      } else {
        _snackBarInfo("Campo Senha incorreto!");
        return validado;
      }
    } else {
      _snackBarInfo("Campo E-mail incorreto!");
      return validado;
    }
  }

  bool _validarSenha() {
    bool _senhaValidada = false;
    String senha1 = senhaEditingController.text;
    String senha2 = confirmaEditingController.text;

    if (senha1 == senha2) {
      _senhaValidada = true;
      _editando = false;
      return _senhaValidada;
    } else {
      return _senhaValidada;
    }
  }

  _salvarCadastro(UserProfile usuario) {
    String email = emailEditingController.text;
    String senha = senhaEditingController.text;
    setState(() {
      _buttonText = "Criando sua conta...";
    });
    auth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {
      //Definir o UID a ser salvo
      usuario.userid = firebaseUser.user!.uid;
      db
          .collection("users")
          .doc(firebaseUser.user!.uid)
          .set(usuario.toMap())
          .then((value) {
        setState(() {
          _buttonText = "Conta Salva!";
        });
        _recuperarCsgoStats(usuario.steamid, usuario.name, usuario.urlimage);
      });
    }).catchError((error) {
      print("erro: " + error.toString());
      setState(() {
        _buttonText = "Erro ao Cadastrar, tente novamente!";
      });
      _editando = true;
    });
  }

  _recuperarCsgoStats(String steamid, String nome, String urlimage) async {
    UserStats? csgoStats = UserStats();
    Api api = Api();
    csgoStats = await (api.updateUserStats(
        steamapikey!, steamid, nome, urlimage) as FutureOr<UserStats>);

    if (csgoStats.kill != "") {
      User user = auth.currentUser!;

      db
          .collection("users")
          .doc(user.uid)
          .update(csgoStats.toMap())
          .then((value) {
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, RouteGenerator.homeRoute);
        });
      });
    } else {
      setState(() {
        _buttonText = "Erro ao Cadastrar, tente novamente!";
      });
      _editando = true;
    }
  }

  //Botão do Snackbar
  void _snackBarInfo(String campoVazio) {
    final snackBar = SnackBar(
      backgroundColor: Colors.amber,
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
    _recuperarAdmKeys();
    super.initState();
  }

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    steamapikey = prefs.getString("steamapikey");
    youtubeapikey = prefs.getString("senhaUser");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 50, bottom: 10, left: 40, right: 40),
                child: Text(
                  "Estamos quase lá...",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: paleta.dodgerBlue, fontSize: 24),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 40, left: 40, right: 40),
                child: Center(
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.userProfile!.urlimage != null
                                    ? widget.userProfile!.urlimage
                                    : null),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                child: TextField(
                  enabled: _editando,
                  controller: emailEditingController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Seu e-mail",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      // width: _largura,
                      flex: 1,
                      child: TextField(
                        enabled: _editando,
                        controller: senhaEditingController,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Sua senha",
                          labelStyle: TextStyle(color: Colors.white),
                          counterStyle: TextStyle(color: paleta.dodgerBlue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(8)),
                    Expanded(
                      // width: _largura,
                      flex: 1,
                      child: TextField(
                        enabled: _editando,
                        controller: confirmaEditingController,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          labelText: "Confirme a senha",
                          labelStyle: TextStyle(color: Colors.white),
                          counterStyle: TextStyle(color: paleta.dodgerBlue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
                child: TextField(
                  enabled: _editando,
                  controller: timeEditingController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: "Tag do seu time (se tiver)",
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.group_outlined,
                      color: paleta.orange,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onChanged: (codigo) {},
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 50, bottom: 50, left: 40, right: 40),
                child: ElevatedButton(
                  child: Text(_buttonText, style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    primary: paleta.dodgerBlue,
                    textStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _processoCadastral();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
