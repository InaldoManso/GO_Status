import 'package:go_status/screen_adm/register/registration_steam_id.dart';
import 'package:go_status/screen_adm/register/registration_user.dart';
import 'package:go_status/screen_adm/splash/splash_screen.dart';
import 'package:go_status/screen_pop/publication_creator.dart';
import 'package:go_status/screen_pop/post_image_view.dart';
import 'package:go_status/screen_pop/reset_password.dart';
import 'package:go_status/screen_adm/register/login.dart';
import 'package:go_status/screen_adm/home/home.dart';
import 'package:go_status/screen_pop/help_url.dart';
import 'package:go_status/screen_pop/help_id.dart';
import 'package:go_status/screen_pop/logout.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String splashRoute = "/splash";
  static const String homeRoute = "/home";
  static const String loginRoute = "/login";
  static const String registrationRoute = "/registrationRoute";
  static const String registerStemIdRoute = "/steamid";
  static const String logoutRoute = "/logout";
  static const String resetPasswordRoute = "/resetpassword";
  static const String helpUrlRoute = "/helpurl";
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
        return MaterialPageRoute(builder: (_) => RegistrationUser(argument));

      case registerStemIdRoute:
        return MaterialPageRoute(builder: (_) => RegistrationSteamId());

      case logoutRoute:
        return MaterialPageRoute(builder: (_) => Logout());

      case resetPasswordRoute:
        return MaterialPageRoute(builder: (_) => ResetPassword());

      case helpUrlRoute:
        return MaterialPageRoute(builder: (_) => HelpUrl());

      case helpIdRoute:
        return MaterialPageRoute(builder: (_) => HelpId());

      case postCreatorRoute:
        return MaterialPageRoute(builder: (_) => PublicationCreator());

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
