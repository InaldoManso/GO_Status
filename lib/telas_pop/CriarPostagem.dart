import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Postagem.dart';

class CriarPostagem extends StatefulWidget {
  @override
  _CriarPostagemState createState() => _CriarPostagemState();
}

class _CriarPostagemState extends State<CriarPostagem> {
  //Atributos Firebase
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Atributos
  TextEditingController _controllerTexto = TextEditingController();
  Paleta paleta = Paleta();
  Postagem postagem = Postagem();

  String _iduser;
  String _nomeuser;
  String _imageuser;
  String _texto;
  String _horario;

  recuperarDadosUser() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    setState(() {
      _iduser = snapshot["userid"];
      _nomeuser = snapshot["nome"];
      _imageuser = snapshot["urlimage"];
    });
  }

  @override
  void initState() {
    recuperarDadosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar postagem"),
        iconTheme: IconThemeData(color: paleta.royalBlue),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: paleta.grey850,
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            child: _imageuser == ""
                                ? CircularProgressIndicator()
                                : ClipOval(child: Image.network(_imageuser)),
                            radius: 20,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Text(
                              _nomeuser,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Divider(color: paleta.royalBlue),
                    ),
                    TextField(
                      minLines: 3,
                      maxLines: 10,
                      maxLength: 300,
                      controller: _controllerTexto,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Digite aqui",
                        labelStyle: TextStyle(color: Colors.grey),
                        counterStyle: TextStyle(color: Colors.white),
                        //Borda externa
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey)),
                      ),
                    ),
                    Image.asset("images/steamidzoom.jpg"),
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Divider(color: paleta.royalBlue),
                    ),
                  ],
                ),
              ),
              Padding(
                  child: RaisedButton(
                      color: paleta.royalBlue,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Publicar",
                        style: TextStyle(fontSize: 16),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {}),
                  padding: EdgeInsets.all(20))
            ],
          ),
        ),
      ),
    );
  }
}
