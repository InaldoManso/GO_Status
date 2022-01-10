import 'package:go_status/core/tools/date_formatter.dart';
import 'package:go_status/features/timeline/aplication/post_editor.dart';
import 'package:go_status/features/timeline/aplication/post_interactive.dart';
import 'package:go_status/features/timeline/model/post_reaction.dart';
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
  ColorPallete colorPallete = ColorPallete();

  //Attributes
  final _controller = StreamController<QuerySnapshot>.broadcast();
  List<String> itensMenu = ["Deletar"];
  String? youtubeapikey;
  String? steamapikey;

  //User attributes
  String? _uidUser = "";
  String? _nameUser = "";
  int? _admin = 0;

  _recuperarAdmKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      steamapikey = prefs.getString("steamapikey");
      youtubeapikey = prefs.getString("youtubeapikey");
    });
  }

  _recoverUserData() async {
    User user = auth.currentUser!;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    setState(() {
      _admin = snapshot["admin"];
      _nameUser = snapshot["name"];
      _uidUser = snapshot["userid"];
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
        _showDialog('Deseja excluir essa postagem?', option);
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

  _sendPostReaction(int reactionId, String? postId) {
    PostInteractive postInteractive = PostInteractive();
    PostReaction postReaction = PostReaction();
    DateFormatter dateFormatter = DateFormatter();
    postReaction.idreaction = reactionId;
    postReaction.uidUser = _uidUser;
    postReaction.nameUser = _nameUser;
    postReaction.timeReaction = dateFormatter.generateDateTime();
    postReaction.type = "love";
    postInteractive.sendGoodGame(postId, postReaction);
  }

  _removePostReaction(String? postId) {
    PostInteractive postInteractive = PostInteractive();
    postInteractive.removeGoodGame(postId!, _uidUser!);
  }

  Future<List<PostReaction>> _listReation(String? postId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<PostReaction> listaUsuarios = [];

    QuerySnapshot querySnapshot = await db
        .collection('publications')
        .doc(postId)
        .collection('reactions')
        .get();

    print('object: ' + querySnapshot.toString());

    for (DocumentSnapshot? item in querySnapshot.docs) {
      DocumentSnapshot<Object?>? dados = item;

      PostReaction postReaction = PostReaction();
      postReaction.idreaction = dados!["idreaction"];
      postReaction.nameUser = dados["nameUser"];
      postReaction.timeReaction = dados["timeReaction"];
      postReaction.type = dados["type"];
      postReaction.uidUser = dados["uidUser"];

      listaUsuarios.add(postReaction);
    }

    return listaUsuarios;
  }

  _showDialog(String messageId, Map<String, dynamic> option) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Apagar publicação"),
          titlePadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(20),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          titleTextStyle: const TextStyle(fontSize: 16, color: Colors.blue),
          contentTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
          content: Text(messageId, textAlign: TextAlign.center),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: colorPallete.grey800,
          actions: <Widget>[
            TextButton(
              child: const Text("Não", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Sim", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                PostEditor().excludePost(option);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
          "Olá " + _nameUser! + "!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          _admin! > 0
              ? IconButton(
                  icon: Icon(
                    Icons.post_add_outlined,
                    color: colorPallete.dodgerBlue,
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
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container();
              case ConnectionState.waiting:
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: CircularProgressIndicator()),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                QuerySnapshot? querySnapshot =
                    snapshot.data as QuerySnapshot<Object?>?;

                if (snapshot.hasError) {
                  return Container(
                    child: Text("Erro ao carregar dados"),
                  );
                } else {
                  return ListView.builder(
                    itemCount: querySnapshot!.docs.length,
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
                            color: colorPallete.grey800,
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8, right: 16),
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
                                    icon: _admin! > 0
                                        ? PopupMenuButton<String>(
                                            color: colorPallete.grey900,
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
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                postagem.message,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
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
                            Row(
                              children: [
                                Expanded(
                                  child: FutureBuilder(
                                    future: _listReation(item["idpublication"]),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                          return Container();
                                        case ConnectionState.waiting:
                                          return TextButton.icon(
                                            label: Text('...'),
                                            icon: Icon(
                                                Icons.favorite_border_outlined,
                                                color: colorPallete.orange),
                                            onPressed: () {},
                                          );
                                        case ConnectionState.active:
                                        case ConnectionState.done:
                                          List<PostReaction> listReactions =
                                              snapshot.data
                                                  as List<PostReaction>;
                                          bool liked = false;
                                          liked = listReactions.any((element) =>
                                              element.uidUser == _uidUser);
                                          return TextButton.icon(
                                            label: Text(
                                              listReactions.length.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            icon: liked
                                                ? Icon(Icons.favorite,
                                                    color: colorPallete.orange)
                                                : Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: colorPallete.orange),
                                            onPressed: () {
                                              if (liked) {
                                                _removePostReaction(
                                                    postagem.idpublication);
                                                setState(() {});
                                              } else {
                                                _sendPostReaction(
                                                    1, postagem.idpublication);
                                                setState(() {});
                                              }
                                            },
                                            onLongPress: () {},
                                          );
                                      }
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: TextButton.icon(
                                    style: TextButton.styleFrom(),
                                    icon: Icon(Icons.comment_outlined,
                                        color: Colors.grey),
                                    label: Text(
                                      'comentar',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    onPressed: () {
                                      Map<String, dynamic> mapPostId = {
                                        'postId': postagem.idpublication
                                      };
                                      Navigator.pushNamed(
                                          context, RouteGenerator.postComments,
                                          arguments: mapPostId);
                                    },
                                  ),
                                ),
                                Spacer()
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
