import 'package:go_status/features/snapping_menu/presentation/widgets/snapping_screen_show.dart';
import 'package:go_status/features/timeline/presentation/widgets/post_comments.dart';
import 'package:go_status/features/timeline/presentation/widgets/publication_creator.dart';
import 'package:go_status/features/reset_password/presentation/reset_password.dart';
import 'package:go_status/features/resgister/presentation/registration_steam_id.dart';
import 'package:go_status/features/timeline/presentation/widgets/post_image_view.dart';
import 'package:go_status/features/resgister/presentation/help_url.dart';
import 'package:go_status/features/resgister/presentation/help_id.dart';
import 'package:go_status/features/resgister/presentation/registration_user.dart';
import 'package:go_status/features/login/presentation/logout.dart';
import 'package:go_status/features/splash_screen/presentation/splash_screen.dart';
import 'package:go_status/features/login/presentation/login.dart';
import 'package:go_status/builds/home/presentation/home.dart';
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
  static const String snappingScreenShow = "/snappingscreenshow";
  static const String postComments = "/postcomments";

  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

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
        return MaterialPageRoute(builder: (_) => RegistrationUser(arguments));

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
        return MaterialPageRoute(
            builder: (_) => PostImageView(arguments as String?));

      case snappingScreenShow:
        return MaterialPageRoute(builder: (_) => SnappingScreenShow(arguments));

      case postComments:
        return MaterialPageRoute(builder: (_) => PostComments(arguments));

      default:
        return _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Tela n??o encontrada")),
        body: Center(
          child: Text("Tela n??o encontrada"),
        ),
      );
    });
  }
}
