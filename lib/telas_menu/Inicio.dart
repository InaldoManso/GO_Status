import 'dart:async';

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
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  Paleta paleta = Paleta();
  String steamapikey;
  String youtubeapikey;
  String _nomeUser = "";
  int _admin;

  Stream<QuerySnapshot> _adicionarListenerMensagens() {
    final stream = db
        .collection("postagens")
        .orderBy("idtime", descending: true)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
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
    _adicionarListenerMensagens();

    setState(() {
      _admin = snapshot["admin"];
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
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Olá " + _nomeUser + "!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          _admin > 0
              ? IconButton(
                  icon: Icon(
                    Icons.post_add_outlined,
                    color: paleta.royalBlue,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, RouteGenerator.CRIARPOST_ROTA);
                  },
                )
              : Container()
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: _controller.stream,
          // ignore: missing_return
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot querySnapshot = snapshot.data;

                if (snapshot.hasError) {
                  return Container(
                    child: Text("Erro ao carregar dados"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, index) {
                      //Recuperar mensagens
                      List<DocumentSnapshot> postagens =
                          querySnapshot.docs.toList();

                      DocumentSnapshot item = postagens[index];
                      Postagem postagem = Postagem();
                      postagem.idtime = item["idtime"];
                      postagem.idpostagem = item["idpostagem"];
                      postagem.idtipo = item["idtipo"];
                      postagem.iduser = item["iduser"];
                      postagem.nomeuser = item["nomeuser"];
                      postagem.imageuser = item["imageuser"];
                      postagem.texto = item["texto"];
                      postagem.urlimage = item["urlimage"];
                      postagem.horario = item["horario"];

                      return Container(
                        margin: EdgeInsets.only(top: 8, bottom: 8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: paleta.grey850,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 16, right: 16),
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
                                    child: Text(
                                      postagem.nomeuser,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Container(
                              child: SingleChildScrollView(
                                child: Text(
                                  postagem.texto,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteGenerator.POSTIMAGE_ROTA,
                                    arguments: postagem.urlimage);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: MediaQuery.of(context).size.width * 0.6,
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(postagem.urlimage),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                break;
            }
            return null;
          },
        ),
      ),
    );
  }
}

/*
FutureBuilder<List<Postagem>>(
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
                  _admin > 0
                      ? IconButton(
                          icon: Icon(
                            Icons.post_add_outlined,
                            color: paleta.royalBlue,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RouteGenerator.CRIARPOST_ROTA);
                          },
                        )
                      : Container()
                ],
              ),
              body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, indice) {
                  List<Postagem> listaItens = snapshot.data;
                  Postagem postagem = listaItens[indice];

                  return Container(
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: paleta.grey850,
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
                                child: Text(
                                  postagem.nomeuser,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(color: paleta.royalBlue),
                        Container(
                          child: SingleChildScrollView(
                            child: Text(
                              postagem.texto,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteGenerator.POSTIMAGE_ROTA,
                                arguments: postagem.urlimage);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: MediaQuery.of(context).size.width * 0.6,
                            alignment: Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                  image: NetworkImage(postagem.urlimage),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        Divider(color: paleta.royalBlue),
                      ],
                    ),
                  );
                },
              ),
            );
            break;
        }
        return null;
      },
    )
*/
