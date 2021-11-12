import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';

class HelpUrl extends StatefulWidget {
  @override
  _HelpUrlState createState() => _HelpUrlState();
}

class _HelpUrlState extends State<HelpUrl> {
  ColorPallete paleta = ColorPallete();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50, bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text(
                "Como encontrar sua URL personalizada",
                style: TextStyle(fontSize: 24, color: paleta.dodgerBlue),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text("Vá em: Steam> Perfil> EditarPerfil> Aba Geral:"),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/helpers/steamurl.jpg"),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text(
                "Preencha com a ultima parte da\nsua URL personalizada",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage("assets/image/helpers/steamurlzoom.jpg"),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            RaisedButton(
                color: paleta.dodgerBlue,
                textColor: Colors.white,
                padding: EdgeInsets.all(15),
                child: Text("Entendi"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
