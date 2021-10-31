import 'package:flutter/material.dart';
import 'package:go_status/telas_cadastro/Cadastro.dart';
import 'package:go_status/telas_adm/Home.dart';
import 'package:go_status/telas_adm/Login.dart';
import 'package:go_status/telas_adm/SplashScreen.dart';
import 'package:go_status/telas_cadastro/SteamId.dart';
import 'package:go_status/telas_pop/CriarPostagem.dart';
import 'package:go_status/telas_pop/HelpID.dart';
import 'package:go_status/telas_pop/HelpURL.dart';
import 'package:go_status/telas_pop/Logout.dart';
import 'package:go_status/telas_pop/PostImageView.dart';
import 'package:go_status/telas_pop/TelaReset.dart';

class RouteGenerator {
  static const String splashRoute = "/splash";
  static const String homeRoute = "/home";
  static const String loginRoute = "/login";
  static const String registrationRoute = "/registrationRoute";
  static const String registerStemIdRoute = "/steamid";
  static const String logoutRoute = "/logout";
  static const String resetPasswordRoute = "/resetpassword";
  static const String gelpUrlRoute = "/helpurl";
  static const String helpIdRoute = "/helpid";
  static const String postCreatorRoute = "/postcreator";
  static const String viewPostRoute = "/postimage";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final argument = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case homeRoute:
        return MaterialPageRoute(builder: (_) => Home());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => Login());

      case registrationRoute:
        return MaterialPageRoute(builder: (_) => Cadastro(argument));

      case registerStemIdRoute:
        return MaterialPageRoute(builder: (_) => SteamId());

      case logoutRoute:
        return MaterialPageRoute(builder: (_) => Logout());

      case resetPasswordRoute:
        return MaterialPageRoute(builder: (_) => TelaReset());

      case gelpUrlRoute:
        return MaterialPageRoute(builder: (_) => HelpURL());

      case helpIdRoute:
        return MaterialPageRoute(builder: (_) => HelpId());

      case postCreatorRoute:
        return MaterialPageRoute(builder: (_) => CriarPostagem());

      case viewPostRoute:
        return MaterialPageRoute(builder: (_) => PostImageView(argument));

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
