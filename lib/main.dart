import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/telas_adm/SplashScreen.dart';

void main() async {
  //Iniciar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final ThemeData theme = ThemeData();
  Paleta paleta = Paleta();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.transparent),
        colorScheme: theme.colorScheme.copyWith(secondary: paleta.orange),
        accentColor: paleta.orange,
        primaryColor: paleta.royalBlue,
        backgroundColor: paleta.grey850,
        scaffoldBackgroundColor: paleta.grey900,
        iconTheme: IconThemeData(color: paleta.royalBlue),
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

/*
Cor destaque: 0xff4876FF


ThemeData(
        brightness: Brightness.dark,
        primaryColor: paleta.royalBlue,
        backgroundColor: paleta.grey850,
        scaffoldBackgroundColor: paleta.grey900,
        iconTheme: IconThemeData(color: paleta.royalBlue),
        colorScheme: theme.colorScheme.copyWith(secondary: paleta.orange),
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
          bodyText2: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
        ),
      ),

*/
