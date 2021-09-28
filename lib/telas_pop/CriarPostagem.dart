import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Postagem.dart';

class CriarPostagem extends StatefulWidget {
  @override
  _CriarPostagemState createState() => _CriarPostagemState();
}

class _CriarPostagemState extends State<CriarPostagem> {
  //Atributos
  TextEditingController _controllerTexto = TextEditingController();
  Paleta paleta = Paleta();
  Postagem postagem = Postagem();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: paleta.royalBlue),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Escreva para que todos vejam!",
          style: TextStyle(color: paleta.royalBlue),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                child: TextField(
                  minLines: 5,
                  maxLines: 10,
                  maxLength: 300,
                  controller: _controllerTexto,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Digite aqui",
                    labelStyle: TextStyle(color: Colors.grey),
                    //Borda externa
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
                padding: EdgeInsets.all(20)),
            Padding(
                child: RaisedButton(
                    color: paleta.royalBlue,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Enviar",
                      style: TextStyle(fontSize: 16),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {}),
                padding: EdgeInsets.all(20))
          ],
        ),
      ),
    );
  }
}
