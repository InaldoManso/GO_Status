import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/model/Usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //Atributos
  TextEditingController _controllerEmail =
      TextEditingController(text: "inaldo@gmail.com");
  // TextEditingController();
  TextEditingController _controllerSenha =
      TextEditingController(text: "123456");
  // TextEditingController();

  //
  IconData _iconSenha = Icons.visibility_off_outlined;
  Paleta paleta = Paleta();
  bool _esconderSenha = true;
  bool _carregando = false;

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    _carregando = true;
    _exibirCarregando();

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;
        _logarUsuario(usuario);
      } else {
        _carregando = false;
        _exibirCarregando();
        _snackBarInfo("Preencha a senha!");
      }
    } else {
      _carregando = false;
      _exibirCarregando();
      _snackBarInfo("Preencha o email!");
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      Timer(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, RouteGenerator.HOME_ROTA);
      });
    }).catchError((error) {
      _snackBarInfo(
          "Erro ao autenticar usuário, verifique seus dados e tente novamente");
      _carregando = false;
      _exibirCarregando();
    });
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

  _iniciarCadastro() {
    //Enviar para cadastro
    Navigator.pushNamed(context, RouteGenerator.STEAMID_ROTA);
  }

  _exibirSenha() {
    if (_esconderSenha) {
      setState(() {
        _esconderSenha = false;
        _iconSenha = Icons.visibility_outlined;
      });
    } else {
      setState(() {
        _esconderSenha = true;
        _iconSenha = Icons.visibility_off_outlined;
      });
    }
  }

  Widget _exibirCarregando() {
    Widget widget;

    if (_carregando) {
      setState(() {
        widget = Container(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(backgroundColor: Colors.white));
      });
    } else {
      setState(() {
        widget = Text("Entrar", style: TextStyle(fontSize: 20));
      });
    }
    return widget;
  }

  _recuperarSenha() {
    String email = _controllerEmail.text;

    if (email.isNotEmpty && email.contains("@")) {
      FirebaseAuth auth = FirebaseAuth.instance;
      auth.sendPasswordResetEmail(email: email).then((value) {
        Navigator.pushNamed(context, RouteGenerator.TELARESET_ROTA);
      }).catchError((onError) {
        _snackBarInfo(
            "Erro ao realizar o reset, verifique seus dados e tente novamente");
      });
    } else {
      _snackBarInfo("Preencha o e-mail para o reset!");
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
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
              Padding(
                padding: EdgeInsets.fromLTRB(40, 30, 40, 10),
                child: TextField(
                  controller: _controllerEmail,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Digite seu e-mail",
                    //Borda externa
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: TextField(
                  controller: _controllerSenha,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  obscureText: _esconderSenha,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Senha de 6 dígitos",
                    suffixIcon: IconButton(
                        icon: Icon(_iconSenha),
                        onPressed: (() {
                          _exibirSenha();
                        })),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: RaisedButton(
                    color: paleta.royalBlue,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: _exibirCarregando(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      _carregando = true;
                      _exibirCarregando();
                      _validarCampos();
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text("Cadastre-se",
                          style: TextStyle(fontSize: 18, color: paleta.orange)),
                      onTap: () {
                        _iniciarCadastro();
                      },
                    ),
                    Text(" | ", style: TextStyle(fontSize: 16)),
                    GestureDetector(
                      child: Text("Esqueci minha senha",
                          style: TextStyle(
                            fontSize: 16,
                          )),
                      onTap: () {
                        _recuperarSenha();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
