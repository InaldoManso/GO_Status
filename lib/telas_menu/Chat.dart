import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/DateFormatter.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/Mensagem.dart';
import 'package:go_status/model/Usuario.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  //Atributos
  final _controller = StreamController<QuerySnapshot>.broadcast();
  ScrollController _scrollController = ScrollController();
  TextEditingController _controllerMensagem = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateFormatter dateFormatter = DateFormatter();
  Usuario usuario = Usuario();
  Paleta paleta = Paleta();

  String _idUser;
  String _nomeUser;

  _enviarMensagem() {
    String texto = _controllerMensagem.text;
    Mensagem mensagem = Mensagem();

    if (texto.isNotEmpty) {
      mensagem.iduser = _idUser;
      mensagem.nome = _nomeUser;
      mensagem.mensagem = texto;
      mensagem.urlimage = "urlExemplo";
      mensagem.tipo = "1";
      mensagem.horaexibir = DateTime.now().toString();
      mensagem.time =
          dateFormatter.gerarHoraIdMensagem(DateTime.now().toString());
      _salvarMensagem(mensagem);
    }
  }

  _salvarMensagem(Mensagem mensagem) async {
    await db
        .collection("chatgeral")
        .add(mensagem.toMap())
        .then((value) => _controllerMensagem.clear());
  }

  Stream<QuerySnapshot> _adicionarListenerMensagens() {
    final stream = db
        .collection("chatgeral")
        .orderBy("time", descending: false)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
      //Sempre que atualizar, rolar para o fim
      Timer(Duration(milliseconds: 200), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    });
  }

  _recuperarDadosUser() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User user = auth.currentUser;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(user.uid).get();
    _adicionarListenerMensagens();

    _idUser = user.uid;
    _nomeUser = snapshot["nome"];
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
                    controller: _scrollController,
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, index) {
                      //Recuperar mensagens
                      List<DocumentSnapshot> mensagens =
                          querySnapshot.docs.toList();

                      DocumentSnapshot item = mensagens[index];

                      Alignment alinhamento = Alignment.centerRight;
                      Color color = paleta.orange;
                      double laguraContainer =
                          MediaQuery.of(context).size.width * 0.8;

                      if (_idUser != item["iduser"]) {
                        color = paleta.royalBlue;
                        alinhamento = Alignment.centerLeft;
                      }
                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: laguraContainer,
                            decoration: BoxDecoration(
                                color: color,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _idUser != item["iduser"]
                                    ? Text(item["nome"],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 12))
                                    : Container(),
                                _idUser != item["iduser"]
                                    ? Divider(color: Colors.grey[100])
                                    : Container(),
                                Text(item["mensagem"],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16)),
                                Text(
                                    dateFormatter
                                        .exibirHoraMin(item["horaexibir"]),
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
                        _enviarMensagem();
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
ListView.builder(
            itemCount: listaMensagens.length,
            itemBuilder: (context, indice) {
              Alignment alinhamento = Alignment.centerRight;
              Color color = paleta.orange;
              double laguraContainer = MediaQuery.of(context).size.width * 0.8;

              if (indice % 2 == 0) {
                color = paleta.royalBlue;
                alinhamento = Alignment.centerLeft;
              }
              return Align(
                alignment: alinhamento,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: laguraContainer,
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Text(listaMensagens[indice],
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              );
            })
*/