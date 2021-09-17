import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/helper/RouteGenerator.dart';
import 'package:go_status/model/Postagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Paleta paleta = Paleta();
  String steamapikey;
  String youtubeapikey;
  String _nomeUser = "";

  Future<List<Postagem>> _recuperarPostagens() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("postagens")
        .orderBy("idtime", descending: true)
        .get();

    List<Postagem> listaPosts = [];
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data();

      Postagem postagem = Postagem();
      postagem.idpostagem = dados["idpostagem"];
      postagem.idtime = dados["idtime"];
      postagem.iduser = dados["iduser"];
      postagem.idtipo = dados["idtipo"];
      postagem.nomeuser = dados["nomeuser"];
      postagem.imageuser = dados["imageuser"];
      postagem.texto = dados["texto"];
      postagem.horario = dados["horario"];

      listaPosts.add(postagem);
    }

    return listaPosts;
  }

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      steamapikey = prefs.getString("steamapikey");
      youtubeapikey = prefs.getString("youtubeapikey");
    });
  }

  _recuperarDadosUsuario() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();

    setState(() {
      _nomeUser = snapshot["nome"];
    });
  }

  @override
  void initState() {
    _recuperarAdmKeys();
    _recuperarDadosUsuario();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double telaHeight = MediaQuery.of(context).size.height;
    double telaWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Postagem>>(
      future: _recuperarPostagens(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: Column(
                children: <Widget>[
                  Text("Carregando contatos"),
                  CircularProgressIndicator()
                ],
              ),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                title: Text(
                  "Olá " + _nomeUser + "!",
                  style: TextStyle(color: paleta.royalBlue),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.post_add_outlined,
                      color: paleta.royalBlue,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RouteGenerator.CRIARPOST_ROTA);
                    },
                  ),
                ],
              ),
              body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, indice) {
                  List<Postagem> listaItens = snapshot.data;
                  Postagem postagem = listaItens[indice];

                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: CircleAvatar(
                                  child: postagem.imageuser == ""
                                      ? CircularProgressIndicator()
                                      : ClipOval(
                                          child: Image.network(
                                            postagem.imageuser,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                  radius: 20,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Text(postagem.nomeuser),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: paleta.royalBlue,
                          ),
                          Container(
                            height: telaHeight / 7,
                            child: SingleChildScrollView(
                              child: Text(postagem.texto),
                            ),
                          ),
                          Divider(
                            color: paleta.royalBlue,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
            break;
        }
        return null;
      },
    );
  }
}
