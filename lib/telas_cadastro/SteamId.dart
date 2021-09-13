import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/helper/Api.dart';
import 'package:go_status/model/Usuario.dart';
import 'package:http/http.dart' as http;

class SteamId extends StatefulWidget {
  @override
  _SteamIdState createState() => _SteamIdState();
}

class _SteamIdState extends State<SteamId> {
  //Models&Helpers
  Paleta paleta = Paleta();
  Api api = Api();
  Usuario usuario = Usuario();

  //Atributos
  TextEditingController nomeEditingController = TextEditingController();
  String _labelTextField = "exemplo: MeuNome123";

  String _idSelecionado = "url";
  bool _userEncontrado = false;
  bool _procurando = false;

  //Atributos User
  String _steamInfo = "";
  String _urlImage = "";
  String _steamID = "";
  String _steamNome = "";
  String _steamPais = "";

  _recSteamURL(String steamName) async {
    http.Response response = await http.get(api.recSteamURL + steamName);

    //Decodificar o resultado (String to Json)
    Map<String, dynamic> retorno = json.decode(response.body);

    String sucesso = retorno["response"]["success"].toString();

    if (sucesso == "1") {
      String steamId = retorno["response"]["steamid"].toString();
      _recSteamID(steamId);
    } else {
      _userEncontrado = false;
      _procurando = false;
      _urlImage = "";
      setState(() {});
    }
  }

  _recSteamID(String steamID) async {
    http.Response response = await http.get(api.recSteamID + steamID);

    //Decodificar o resultado (String to Json)
    Map<String, dynamic> retorno = json.decode(response.body);
    if (retorno["response"]["players"].toString() != "[]") {
      _urlImage = retorno["response"]["players"][0]["avatarfull"].toString();
      _steamID = retorno["response"]["players"][0]["steamid"].toString();
      _steamNome = retorno["response"]["players"][0]["personaname"].toString();
      _steamPais =
          retorno["response"]["players"][0]["loccountrycode"].toString();
      _userEncontrado = true;
      _procurando = false;
      setState(() {});
    } else {
      setState(() {
        _userEncontrado = false;
        _procurando = false;
        _urlImage = "";
      });
    }
  }

  _enviarCadastro() {
    Usuario usuario = Usuario();
    usuario.nome = _steamNome;
    usuario.email = "";
    usuario.senha = "";
    usuario.steamid = _steamID;
    usuario.time = "";
    usuario.urlimage = _urlImage;
    usuario.pais = _steamPais;

    Navigator.pushNamed(context, RouteGenerator.CADASTRO_ROTA,
        arguments: usuario);
  }

  void _snackBarInfo(String mensagem) {
    final snackBar = SnackBar(
      backgroundColor: paleta.orange,
      duration: Duration(seconds: 4),
      content: Text(mensagem,
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 70, 10, 20),
                child: Text(
                  "Vamos encontrar seu perfil!",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, color: paleta.royalBlue),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  children: <Widget>[
                    Radio(
                        value: "url",
                        groupValue: _idSelecionado,
                        onChanged: (String escolha) {
                          _idSelecionado = escolha;
                          _labelTextField = "exemplo: MeuNome123";
                          setState(() {});
                        }),
                    Text("URL personalizada"),
                    Radio(
                        value: "steamid",
                        groupValue: _idSelecionado,
                        onChanged: (String escolha) {
                          _idSelecionado = escolha;
                          _labelTextField = "exemplo: 12345678910111213";
                          setState(() {});
                        }),
                    Text("Steam ID"),
                    Expanded(
                      child: Container(
                        // padding: EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            icon: Icon(Icons.help_outline_outlined),
                            onPressed: () {
                              if (_idSelecionado == "url") {
                                Navigator.pushNamed(
                                    context, RouteGenerator.HELPURL_ROTA);
                              } else {
                                Navigator.pushNamed(
                                    context, RouteGenerator.HELPID_ROTA);
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 60,
                          child: TextField(
                            //enabled: _editando,
                            controller: nomeEditingController,
                            keyboardType: TextInputType.name,
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: _labelTextField,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (steamInfo) {
                              _steamInfo = steamInfo;
                            },
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(4)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 60,
                          width: 60,
                          child: RaisedButton(
                              color: paleta.royalBlue,
                              textColor: Colors.white,
                              padding: EdgeInsets.all(15),
                              child: _procurando
                                  ? Container(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ))
                                  : Icon(Icons.search),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: () {
                                if (_steamInfo.length > 0) {
                                  setState(() {
                                    _procurando = true;
                                  });
                                  if (_idSelecionado == "url") {
                                    _recSteamURL(_steamInfo);
                                  } else {
                                    _recSteamID(_steamInfo);
                                  }
                                }
                              }),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _userEncontrado
                        ? Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                image: DecorationImage(
                                    image: NetworkImage(_urlImage),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          )
                        : Container(
                            height: 150,
                            width: 150,
                          ),
                    Padding(
                      padding: EdgeInsets.all(4),
                    ),
                    Expanded(
                      child: _userEncontrado
                          ? Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    _steamNome,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    "id: " + _steamID,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  _userEncontrado
                                      ? RaisedButton(
                                          color: paleta.royalBlue,
                                          textColor: Colors.white,
                                          padding: EdgeInsets.all(15),
                                          child:
                                              Text("Acessar como $_steamNome"),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          onPressed: () {
                                            _enviarCadastro();
                                          })
                                      : Container()
                                ],
                              ),
                            )
                          : Container(),
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
