import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  Paleta paleta = Paleta();

  _logout() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.LOGIN_ROTA);
    });
  }

  @override
  void initState() {
    _logout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text("Até breve!",
              style: TextStyle(color: paleta.royalBlue, fontSize: 16)),
        ),
      ),
    );
  }
}
