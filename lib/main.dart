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
      //Iniciar Screen
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),

      //Rotas
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,

      //Tema
      theme: ThemeData(
        scaffoldBackgroundColor: paleta.grey900,
        backgroundColor: paleta.grey900,
        accentColor: paleta.orange,
        primaryColor: paleta.royalBlue,
        iconTheme: IconThemeData(color: paleta.royalBlue),
      ),
    ),
  );
}

/*
Cor destaque: 0xff4876FF


ThemeData(
        scaffoldBackgroundColor: Colors.white,
        accentColor: paleta.orange,
        primaryColor: paleta.royalBlue,
        iconTheme: IconThemeData(color: paleta.royalBlue),
      ),

*/
