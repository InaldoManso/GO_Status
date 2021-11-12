import 'package:go_status/core/tools/route_generator.dart';
import 'package:go_status/features/splash_screen/presentation/splash_screen.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //Iniciar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final ThemeData theme = ThemeData();
  ColorPallete paleta = ColorPallete();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        colorScheme: theme.colorScheme.copyWith(secondary: paleta.orange),
        primaryColor: paleta.dodgerBlue,
        backgroundColor: paleta.grey850,
        scaffoldBackgroundColor: paleta.grey900,
        iconTheme: IconThemeData(color: paleta.dodgerBlue),
        textTheme: const TextTheme(
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
          overline: TextStyle(color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
        ),
      ),
    ),
  );
}
