import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_status/helper/route_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/helper/color_pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/model/publication.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TimeLine extends StatefulWidget {
  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ColorPallete paleta = ColorPallete();

  //Attributes
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _nameUser = "";
  String youtubeapikey;
  String steamapikey;
  int _admin = 0;

  Stream<QuerySnapshot> _addListenerPublications() {
    final stream = db
        .collection("publications")
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
        await db.collection("users").doc(user.uid).get();
    _addListenerPublications();

    setState(() {
      _admin = snapshot["admin"];
      _nameUser = snapshot["name"];
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
          "Olá " + _nameUser + "!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          _admin > 0
              ? IconButton(
                  icon: Icon(
                    Icons.post_add_outlined,
                    color: paleta.dodgerBlue,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                        context, RouteGenerator.postCreatorRoute);
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
                return Container();
                break;
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

                      Publication postagem = Publication();
                      postagem.idtime = item["idtime"];
                      postagem.idpublication = item["idpublication"];
                      postagem.iduser = item["iduser"];
                      postagem.type = item["type"];
                      postagem.nameuser = item["nameuser"];
                      postagem.imageuser = item["imageuser"];
                      postagem.message = item["message"];
                      postagem.urlimage = item["urlimage"];
                      postagem.timeshow = item["timeshow"];

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
                                      postagem.nameuser,
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
                                  postagem.message,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteGenerator.viewPostRoute,
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
