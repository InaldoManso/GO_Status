import 'package:go_status/features/timeline/aplication/post_editor.dart';
import 'package:go_status/features/timeline/tools/option_spliter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_status/core/tools/route_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_status/features/timeline/model/post_item.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PostTimeline extends StatefulWidget {
  @override
  _PostTimelineState createState() => _PostTimelineState();
}

class _PostTimelineState extends State<PostTimeline> {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ColorPallete paleta = ColorPallete();

  //Attributes
  final _controller = StreamController<QuerySnapshot>.broadcast();
  List<String> itensMenu = ["Deletar"];
  String _nameUser = "";
  String youtubeapikey;
  String steamapikey;
  int _admin = 0;

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      steamapikey = prefs.getString("steamapikey");
      youtubeapikey = prefs.getString("youtubeapikey");
    });
  }

  _recoverUserData() async {
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    setState(() {
      _admin = snapshot["admin"];
      _nameUser = snapshot["name"];
    });
  }

  Stream<QuerySnapshot> _addListenerPublications() {
    final stream = db
        .collection("publications")
        .orderBy("idtime", descending: true)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return stream;
  }

  _postOptions(String item) async {
    Map<String, dynamic> option = OptionSpliter().option(item);

    print(option["id"]);

    switch (option["id"]) {
      case "deletar":
        _snackBarInfo(option["id"]);
        PostEditor().excludePost(option);
        break;
      case "reportar":
        _snackBarInfo(option["id"]);
        break;
    }
  }

  void _snackBarInfo(String campoVazio) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content:
          Text(campoVazio, style: TextStyle(fontSize: 16, color: Colors.white)),
      action: SnackBarAction(
          label: "OK", textColor: Colors.white, onPressed: () {}),
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    _recuperarAdmKeys();
    _recoverUserData();
    _addListenerPublications();
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
              : Container(),
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

                      PostItem postagem = PostItem();
                      postagem.idtime = item["idtime"];
                      postagem.idpublication = item["idpublication"];
                      postagem.iduser = item["iduser"];
                      postagem.type = item["type"];
                      postagem.nameuser = item["nameuser"];
                      postagem.imageuser = item["imageuser"];
                      postagem.message = item["message"];
                      postagem.urlimage = item["urlimage"];
                      postagem.timeshow = item["timeshow"];
                      postagem.imageName = item["imageName"];

                      return Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: paleta.grey800,
                            borderRadius: BorderRadius.circular(16)),
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
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    splashRadius: 20,
                                    splashColor: Colors.grey,
                                    iconSize: 30,
                                    icon: _admin > 0
                                        ? PopupMenuButton<String>(
                                            color: paleta.grey900,
                                            icon: Icon(
                                                Icons.more_horiz_outlined,
                                                color: Colors.white),
                                            onSelected: _postOptions,
                                            itemBuilder: (context) {
                                              return itensMenu
                                                  .map((String item) {
                                                return PopupMenuItem<String>(
                                                  value: item +
                                                      "/" +
                                                      postagem.idpublication +
                                                      "/" +
                                                      postagem.iduser +
                                                      "/" +
                                                      postagem.imageName,
                                                  child: Text(
                                                    item,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                );
                                              }).toList();
                                            },
                                          )
                                        : Container(),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                height: MediaQuery.of(context).size.width * 0.5,
                                alignment: Alignment.topLeft,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(postagem.urlimage),
                                      fit: BoxFit.cover),
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteGenerator.viewPostRoute,
                                    arguments: postagem.urlimage);
                              },
                              onDoubleTap: () {},
                            ),
                            Container(
                              padding: EdgeInsets.all(4),
                              child: SingleChildScrollView(
                                child: Text(
                                  postagem.message,
                                  style: TextStyle(color: Colors.white),
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
