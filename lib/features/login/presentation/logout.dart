import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/core/tools/route_generator.dart';

class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  ColorPallete paleta = ColorPallete();

  _logout() {
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, RouteGenerator.loginRoute);
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
              style: TextStyle(color: paleta.dodgerBlue, fontSize: 16)),
        ),
      ),
    );
  }
}
