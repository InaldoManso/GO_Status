import 'package:flutter/material.dart';
import 'package:go_status/helper/color_pallete.dart';

class HelpId extends StatefulWidget {
  @override
  _HelpIdState createState() => _HelpIdState();
}

class _HelpIdState extends State<HelpId> {
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
                "Como encontrar seu Steam ID",
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
                      image: AssetImage("assets/image/helpers/steamid.jpg"),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Text("Preencha apenas os numeros do seu ID"),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/helpers/steamidzoom.jpg"),
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
