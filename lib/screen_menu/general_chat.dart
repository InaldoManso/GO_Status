import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/general/tools/date_formatter.dart';
import 'package:go_status/general/helpers/color_pallete.dart';
import 'package:go_status/model/message.dart';
import 'package:go_status/general/model/user_profile.dart';

class GeneralChat extends StatefulWidget {
  @override
  _GeneralChatState createState() => _GeneralChatState();
}

class _GeneralChatState extends State<GeneralChat> {
  //Classes and Packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  DateFormatter dateFormatter = DateFormatter();
  FirebaseAuth auth = FirebaseAuth.instance;
  ColorPallete paleta = ColorPallete();
  UserProfile usuario = UserProfile();

  //Attributes
  StreamController _controller = StreamController<QuerySnapshot>.broadcast();
  TextEditingController _controllerMensagem = TextEditingController();
  ScrollController _scrollController = ScrollController();
  String _nameUser;
  String _idUser;

  _archiveMessage(messageuser) {
    Message message = Message();

    if (messageuser.isNotEmpty) {
      message.messageid = dateFormatter.generateDateTimeIdentification();
      message.iduser = _idUser;
      message.name = _nameUser;
      message.message = messageuser;
      message.urlimage = "empty";
      message.type = Message.typeMessage;
      message.timeshow = dateFormatter.generateDateTime();
      _sendMessage(message);
    }
  }

  _sendMessage(Message message) async {
    await db
        .collection("generalchat")
        .add(message.toMap())
        .then((value) => _controllerMensagem.clear());
  }

  _addListenerMessages() {
    final stream = db
        .collection("generalchat")
        .orderBy("messageid", descending: false)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
      Timer(Duration(milliseconds: 500), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  _recuperarDadosUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("users").doc(user.uid).get();

    _idUser = user.uid;
    _nameUser = snapshot["name"];
    _addListenerMessages();
  }

  @override
  void initState() {
    _recuperarDadosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Container(
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Column(
                  children: [CircularProgressIndicator()],
                ));
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
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, index) {
                      //Recuperar mensagens
                      List<DocumentSnapshot> mensagens =
                          querySnapshot.docs.toList();

                      DocumentSnapshot item = mensagens[index];

                      Alignment alinhamento = Alignment.centerRight;
                      Color color = paleta.orange;
                      double appWidth = MediaQuery.of(context).size.width;

                      if (_idUser != item["iduser"]) {
                        color = paleta.dodgerBlue;
                        alinhamento = Alignment.centerLeft;
                      }
                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            constraints: BoxConstraints(
                                minWidth: appWidth * 0.3,
                                maxWidth: appWidth * 0.8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _idUser != item["iduser"]
                                    ? Text(item["name"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12))
                                    : Container(),
                                _idUser != item["iduser"]
                                    ? Divider(color: Colors.grey[100])
                                    : Container(),
                                Text(item["message"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    dateFormatter
                                        .showHoursMin(item["timeshow"]),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 10))
                              ],
                            ),
                          ),
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
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: _controllerMensagem,
                      maxLength: 300,
                      minLines: 1,
                      maxLines: 3,
                      style: TextStyle(fontSize: 19),
                      onChanged: (mensagem) {},
                      decoration: InputDecoration(
                        //Espaçamento interior
                        counterText: "",
                        contentPadding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                        hintText: "Digite uma mengem...",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      onTap: () {
                        Timer(Duration(milliseconds: 200), () {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      icon: Icon(Icons.send_outlined),
                      onPressed: () {
                        _archiveMessage(_controllerMensagem.text);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
 Container(
                    constraints:
                        BoxConstraints(minWidth: 100, maxWidth: appWidth * 0.6),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.transparent,
                        minimumSize: Size(88, 36),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      child: Text(
                        "Eu sou " + userProfile.name,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                      ),
                      onPressed: () {
                        _validarUserAndStemPublic();
                      },
                    ),
                  )
*/
