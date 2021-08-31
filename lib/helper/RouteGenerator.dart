import 'package:flutter/material.dart';
import 'package:go_status/telas_cadastro/Cadastro.dart';
import 'package:go_status/telas_adm/Home.dart';
import 'package:go_status/telas_adm/Login.dart';
import 'package:go_status/telas_adm/SplashScreen.dart';
import 'package:go_status/telas_cadastro/SteamId.dart';
import 'package:go_status/telas_pop/HelpID.dart';
import 'package:go_status/telas_pop/HelpURL.dart';
import 'package:go_status/telas_pop/Logout.dart';
import 'package:go_status/telas_pop/TelaReset.dart';

class RouteGenerator {
  //Rotas cadastradas
  static const String SPLASH_ROTA = "/splash";
  static const String HOME_ROTA = "/home";
  static const String LOGIN_ROTA = "/login";
  static const String CADASTRO_ROTA = "/cadastro";
  static const String STEAMID_ROTA = "/steamid";
  static const String LOGOUT_ROTA = "/logout";
  static const String TELARESET_ROTA = "/telareset";
  static const String HELPURL_ROTA = "/helpurl";
  static const String HELPID_ROTA = "/helpid";

  //Retorna uma Rpta de valor dinamico
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //Capturamos os argumentos a serem passados aqui
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case SPLASH_ROTA:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case HOME_ROTA:
        return MaterialPageRoute(builder: (_) => Home());

      case LOGIN_ROTA:
        return MaterialPageRoute(builder: (_) => Login());

      case CADASTRO_ROTA:
        return MaterialPageRoute(builder: (_) => Cadastro(args));

      case STEAMID_ROTA:
        return MaterialPageRoute(builder: (_) => SteamId());

      case LOGOUT_ROTA:
        return MaterialPageRoute(builder: (_) => Logout());

      case TELARESET_ROTA:
        return MaterialPageRoute(builder: (_) => TelaReset());

      case HELPURL_ROTA:
        return MaterialPageRoute(builder: (_) => HelpURL());

      case HELPID_ROTA:
        return MaterialPageRoute(builder: (_) => HelpId());

      /*case ITEM_ROTA:
        return MaterialPageRoute(builder: (_) => Item(args));*/

      //Se for chamada uma rota inválida
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Tela não encontrada")),
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}
