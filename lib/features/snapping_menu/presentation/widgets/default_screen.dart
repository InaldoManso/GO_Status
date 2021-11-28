import 'dart:async';
import 'package:flutter/material.dart';

class DefaultScreen extends StatefulWidget {
  @override
  _DefaultScreenState createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  _delayScreen() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    _delayScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text("Ops!... Página não encontrada :[",
            style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
