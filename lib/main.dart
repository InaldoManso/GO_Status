import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/telas_adm/SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //Iniciar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Paleta paleta = Paleta();

  ThemeData themeDark;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String themeBool = prefs.getString("modoescuro");

  if (themeBool.toLowerCase() == "true") {
    print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
    themeDark = ThemeData(
      scaffoldBackgroundColor: paleta.grey900,
      backgroundColor: paleta.grey900,
      accentColor: paleta.orange,
      primaryColor: paleta.royalBlue,
      iconTheme: IconThemeData(color: paleta.royalBlue),
    );
  } else {
    print("NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN");
    themeDark = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      accentColor: paleta.orange,
      primaryColor: paleta.royalBlue,
      iconTheme: IconThemeData(color: paleta.royalBlue),
    );
  }

  runApp(
    MaterialApp(
      //Iniciar Screen
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

      //Rotas
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,

      //Tema
      theme: themeDark,
    ),
  );
}

/*
Cor destaque: 0xff4876FF


scaffoldBackgroundColor: paleta.grey900,
      backgroundColor: paleta.grey900,
      accentColor: paleta.orange,
      primaryColor: paleta.royalBlue,
      iconTheme: IconThemeData(color: paleta.royalBlue),

*/
