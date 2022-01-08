// ignore_for_file: must_be_immutable
import 'package:go_status/features/timeline/aplication/post_interactive.dart';
import 'package:go_status/features/timeline/model/post_comment.dart';
import 'package:go_status/core/tools/date_formatter.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class PostComments extends StatefulWidget {
  var mapPostId;
  PostComments(this.mapPostId);

  @override
  _PostCommentsState createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
  //Classes and Packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateFormatter dateFormatter = DateFormatter();
  ColorPallete colorPallete = ColorPallete();
  FirebaseAuth auth = FirebaseAuth.instance;

  //Attributes
  StreamController _controller = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerComment = TextEditingController();
  ScrollController _scrollController = ScrollController();
  ColorPallete _colorPallete = ColorPallete();
  String? _postIdentification;
  String? _uidUser;
  String? _nameUser;

  Stream<QuerySnapshot> _addListenercomments() {
    print(widget.mapPostId['postId']);
    final stream = db
        .collection("publications")
        .doc(widget.mapPostId['postId'])
        .collection('comments')
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return stream;
  }

  _recuperarDadosUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User user = auth.currentUser!;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    _uidUser = user.uid;
    _nameUser = snapshot["name"];
    _postIdentification = widget.mapPostId['postId'];
    _addListenercomments();
  }

  _sendPostComment(int reactionId, String? postId) async {
    PostInteractive postInteractive = PostInteractive();
    PostComment postReaction = PostComment();
    DateFormatter dateFormatter = DateFormatter();
    postReaction.idcomment = reactionId;
    postReaction.uidUser = _uidUser;
    postReaction.nameUser = _nameUser;
    postReaction.timeComment = dateFormatter.generateDateTime();
    postReaction.type = "comment";
    postReaction.message = _controllerComment.text;
    bool success = await postInteractive.sendComment(postId, postReaction);

    if (success) {
      _controllerComment.clear();
    } else {}
  }

  @override
  void initState() {
    _recuperarDadosUser();
    _addListenercomments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentários'),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container();
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
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
                    reverse: true,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: querySnapshot!.docs.length,
                    itemBuilder: (context, index) {
                      //Recuperar mensagens
                      List<DocumentSnapshot> mensagens =
                          querySnapshot.docs.toList();

                      DocumentSnapshot item = mensagens[index];
                      Color color = _colorPallete.grey800!;

                      if (_uidUser != item["uidUser"]) {
                        color = _colorPallete.dodgerBlue;
                      }
                      return Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _uidUser != item["uidUser"]
                                ? Text(item["nameUser"],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 12))
                                : Container(),
                            _uidUser != item["uidUser"]
                                ? Divider(color: Colors.grey[100])
                                : Container(),
                            Text(item["message"],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16)),
                            Text(
                                dateFormatter.showHoursMin(item["timeComment"]),
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 10))
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
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: colorPallete.grey800,
              borderRadius: BorderRadius.circular(16)),
          child: TextField(
            controller: _controllerComment,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              labelText: "Deixe seu comentário...",
              labelStyle: TextStyle(color: colorPallete.dodgerBlue),
              counterStyle: TextStyle(color: colorPallete.dodgerBlue),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8)),
              suffixIcon: Material(
                color: Colors.transparent,
                child: IconButton(
                    splashRadius: 22,
                    iconSize: 32,
                    icon: Icon(
                      Icons.send_outlined,
                      color: colorPallete.orange,
                    ),
                    onPressed: (() {
                      _sendPostComment(1, _postIdentification);
                    })),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
