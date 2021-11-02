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
  TextEditingController searchUserEditingController = TextEditingController();
  String _labelTextField = "exemplo: MeuNome123";
  String _idSelecionado = "url";
  bool _searching = false;
  bool _success = false;
  String youtubeapikey;
  String steamapikey;

  _recoverUser(int searchType, String searchUser) async {
    if (searchType == 1) {
      String steamId = await api.recSteamIdFromUrl(steamapikey, searchUser);
      if (steamId != "error") {
        UserProfile userProfileResult =
            await api.recDataUserFromSteamID(steamapikey, steamId);
        _foundUser(true, userData: userProfileResult);
      } else {
        _foundUser(false);
      }
    } else if (searchType == 2) {
      print("DEU INICIO DO ID $searchUser");
      var test = await api.recDataUserFromSteamID(steamapikey, searchUser);
      print("DEU " + test.toString());
      if (test != "error") {
        UserProfile userProfileResult =
            await api.recDataUserFromSteamID(steamapikey, searchUser);
        _foundUser(true, userData: userProfileResult);
      } else {
        _foundUser(false);
      }
    }
  }

  _foundUser(bool success, {UserProfile userData}) {
    if (success) {
      setState(() {
        userProfile = userData;
        _success = true;
        _searching = false;
      });
    } else {
      print("DEU CAPITEI O ERROOO");
      _snackBarInfo("Usuário não encontrado!\nRevise seus dados.");
      setState(() {
        _success = false;
        _searching = false;
      });
    }
  }

  _validarUserAndStemPublic() async {
    bool perfilPublico = false;
    perfilPublico =
        await api.validarSteamPublica(steamapikey, userProfile.steamid);
    if (perfilPublico) {
      _enviarCadastro(userProfile);
    } else {
      _snackBarInfo(
          "Altere as configurações do seu perfil para publicas na steam!");
    }
  }

  _enviarCadastro(UserProfile userProfile) {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Cadastro GO",
          style: TextStyle(color: colorPallete.dodgerBlue),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.help_outline_outlined),
              onPressed: () {
                if (_idSelecionado == "url") {
                  Navigator.pushNamed(context, RouteGenerator.helpUrlRoute);
                } else {
                  Navigator.pushNamed(context, RouteGenerator.helpIdRoute);
                }
              }),
        ],
      ),
      body: _searching
          ? Center(child: CircularProgressIndicator())
          : _seachInterface(_success, userProfile),
    );
  }

  _seachInterface(bool success, UserProfile userProfile) {
    double appWidth = MediaQuery.of(context).size.width;
    if (success) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(userProfile.urlimage),
                    fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        searchUserEditingController.clear();
                        setState(() {
                          _success = false;
                          _searching = false;
                        });
                      },
                    ),
                  ),
                  Container(padding: EdgeInsets.all(4)),
                  Container(
                    constraints:
                        BoxConstraints(minWidth: 100, maxWidth: appWidth * 0.6),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                        minimumSize: Size(88, 36),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      child: Text(
                        "Eu sou " + userProfile.name,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      onPressed: () {
                        _validarUserAndStemPublic();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 60,
                      child: TextField(
                        controller: searchUserEditingController,
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
                        onChanged: (steamInfo) {},
                      ),
                    ),
                  ),
                  Container(padding: EdgeInsets.all(4)),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 60,
                      width: 60,
                      child: RaisedButton(
                        color: colorPallete.dodgerBlue,
                        textColor: Colors.white,
                        padding: EdgeInsets.all(15),
                        child: Icon(Icons.search),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          setState(() {
                            _searching = true;
                          });
                          if (_idSelecionado == "url") {
                            _recoverUser(1, searchUserEditingController.text);
                          } else {
                            _recoverUser(2, searchUserEditingController.text);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }
  }
}

/*
Scaffold(
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
                              onPressed: () {}),
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

*/
