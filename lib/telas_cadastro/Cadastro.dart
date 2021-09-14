import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Api.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/model/CsgoStats.dart';
import 'package:go_status/model/Usuario.dart';

class Cadastro extends StatefulWidget {
  Usuario usuario;
  Cadastro(this.usuario);
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Referencias Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Paleta paleta = Paleta();
  Usuario usuario = Usuario();

  //Atributos
  bool _editando = true;
  String _buttonText = "Criar conta!";

  //Controladores
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController senhaEditingController = TextEditingController();
  TextEditingController confirmaEditingController = TextEditingController();
  TextEditingController timeEditingController = TextEditingController();

  //Validações de métodos
  _processoCadastral() {
    if (_validarCampos()) {
      if (_validarSenha()) {
        //Configurar os dados
        usuario.nome = widget.usuario.nome;
        usuario.email = emailEditingController.text;
        usuario.senha = senhaEditingController.text;
        usuario.steamid = widget.usuario.steamid;
        usuario.time = timeEditingController.text;
        usuario.urlimage = widget.usuario.urlimage;
        usuario.pais = widget.usuario.pais;
        _salvarCadastro(usuario);
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

  _salvarCadastro(Usuario usuario) {
    String email = emailEditingController.text;
    String senha = senhaEditingController.text;
    setState(() {
      _buttonText = "Criando sua conta...";
    });
    auth
        .createUserWithEmailAndPassword(email: email, password: senha)
        .then((firebaseUser) {
      //Definir o UID a ser salvo
      usuario.userid = firebaseUser.user.uid;
      db
          .collection("usuarios")
          .doc(firebaseUser.user.uid)
          .set(usuario.toMap())
          .then((value) {
        setState(() {
          _buttonText = "Conta Salva!";
        });
        _recCsgoStats(usuario.steamid, usuario.nome, usuario.urlimage);
      });
    }).catchError((error) {
      print("erro: " + error.toString());
      setState(() {
        _buttonText = "Erro ao Cadastrar, tente novamente!";
      });
      _editando = true;
    });
  }

  _recCsgoStats(String steamid, String nome, String urlimage) async {
    CsgoStats csgoStats = CsgoStats();
    Api api = Api();
    csgoStats = await api.atualizarStatsCsgo(
        "0850333260EF03D2E0AB3D29A0AC9176", steamid, nome, urlimage);

    if (csgoStats != null) {
      User user = auth.currentUser;

      db
          .collection("usuarios")
          .doc(user.uid)
          .update(csgoStats.toMap())
          .then((value) {
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROTA);
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
                  style: TextStyle(color: paleta.royalBlue, fontSize: 24),
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
                            image: NetworkImage(widget.usuario.urlimage != null
                                ? widget.usuario.urlimage
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
                          counterStyle: TextStyle(color: paleta.royalBlue),
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
                          counterStyle: TextStyle(color: paleta.royalBlue),
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
                child: RaisedButton(
                  color: paleta.royalBlue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Text(_buttonText, style: TextStyle(fontSize: 18)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
