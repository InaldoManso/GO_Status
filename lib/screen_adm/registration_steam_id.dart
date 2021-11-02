import 'package:flutter/material.dart';
import 'package:go_status/helper/color_pallete.dart';
import 'package:go_status/helper/route_generator.dart';
import 'package:go_status/helper/api.dart';
import 'package:go_status/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationSteamId extends StatefulWidget {
  @override
  _RegistrationSteamIdState createState() => _RegistrationSteamIdState();
}

class _RegistrationSteamIdState extends State<RegistrationSteamId> {
  //Models&Helpers
  ColorPallete colorPallete = ColorPallete();
  UserProfile userProfile = UserProfile();
  Api api = Api();

  //Atributos
  TextEditingController nomeEditingController = TextEditingController();
  String _labelTextField = "exemplo: MeuNome123";
  String _idSelecionado = "url";
  bool _procurando = false;
  String youtubeapikey;
  String steamapikey;

  //Atributos User
  String _steamInfo = "";

  _validarPublico() async {
    bool perfilPublico = false;
    perfilPublico =
        await api.validarSteamPublica(steamapikey, userProfile.steamid);
    if (perfilPublico) {
      _enviarCadastro();
    } else {
      _snackBarInfo(
          "Altere as configurações do seu perfil para publicas na steam!");
    }
  }

  _enviarCadastro() {
    Navigator.pushNamed(context, RouteGenerator.registrationRoute,
        arguments: userProfile);
  }

  void _snackBarInfo(String mensagem) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
      content: Text(mensagem,
          style: TextStyle(fontSize: 18, color: Colors.white),
          textAlign: TextAlign.center),
      action: SnackBarAction(
          label: "OK", textColor: Colors.white, onPressed: () {}),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    steamapikey = prefs.getString("steamapikey");
    youtubeapikey = prefs.getString("youtubeapikey");

    print("TEste 01" + steamapikey);
    print("TEste 02" + youtubeapikey);
  }

  @override
  void initState() {
    _recuperarAdmKeys();
    super.initState();
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
                  style:
                      TextStyle(fontSize: 18, color: colorPallete.dodgerBlue),
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
                                    context, RouteGenerator.helpUrlRoute);
                              } else {
                                Navigator.pushNamed(
                                    context, RouteGenerator.helpIdRoute);
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
                              labelStyle: TextStyle(color: Colors.white),
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
                              color: colorPallete.dodgerBlue,
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
                              onPressed: () async {
                                if (_steamInfo.length > 0) {
                                  setState(() {
                                    _procurando = true;
                                  });
                                  if (_idSelecionado == "url") {
                                    // _recSteamURL(_steamInfo);
                                    String dados = await api.recSteamIdFromUrl(
                                        steamapikey, _steamInfo);

                                    userProfile =
                                        await api.recDataUserFromSteamID(
                                            steamapikey, dados);
                                    _procurando = false;
                                    setState(() {});
                                  } else {
                                    // _recSteamID(_steamInfo);
                                    userProfile =
                                        await api.recDataUserFromSteamID(
                                            steamapikey, _steamInfo);
                                    _procurando = false;
                                    setState(() {});
                                  }
                                }
                              }),
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                child: userProfile.name != "" && userProfile.name != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                image: DecorationImage(
                                    image: NetworkImage(userProfile.urlimage),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4),
                          ),
                          Expanded(
                            child: Container(
                              height: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    userProfile.name,
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  Text(
                                    "id: " + userProfile.steamid,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  RaisedButton(
                                    color: colorPallete.dodgerBlue,
                                    textColor: Colors.white,
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                        "Acessar como " + userProfile.name),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    onPressed: () {
                                      _validarPublico();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
