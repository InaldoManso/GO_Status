import 'package:flutter/material.dart';
import 'dart:async';

class TelaReset extends StatefulWidget {
  @override
  _TelaResetState createState() => _TelaResetState();
}

class _TelaResetState extends State<TelaReset> {
  _delayPopTela() {
    //Delay pop da tela
    Timer(Duration(seconds: 4), () {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    _delayPopTela();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Container(
        child: Center(
          child: Text("Reset de senha enviado no seu\nE-mail com sucesso!",
              style: TextStyle(fontSize: 20, color: Colors.white),
              textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
