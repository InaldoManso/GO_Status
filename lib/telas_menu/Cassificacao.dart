import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/model/CassifUser.dart';

class Cassificacao extends StatefulWidget {
  @override
  _CassificacaoState createState() => _CassificacaoState();
}

class _CassificacaoState extends State<Cassificacao> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User _user;
  String _idUsuarioLogado;
  String _emailUsuarioLogado;

  Future<List<ClassifUser>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .orderBy("resultkd", descending: true)
        .get();

    List<ClassifUser> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data();
      //if (dados["email"] == _emailUsuarioLogado) continue;

      ClassifUser classifUser = ClassifUser();
      classifUser.email = dados["email"];
      classifUser.nome = dados["nome"];
      classifUser.urlimage = dados["urlimage"];
      classifUser.resultkd = dados["resultkd"];

      listaUsuarios.add(classifUser);
    }

    return listaUsuarios;
  }

  _recuperarDadosUsuario() async {
    _user = await auth.currentUser;
    _idUsuarioLogado = _user.uid;
    _emailUsuarioLogado = _user.email;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClassifUser>>(
      future: _recuperarContatos(),
      // ignore: missing_return
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
              /*appBar: AppBar(
                backgroundColor: Colors.transparent,
              ),*/
              body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, indice) {
                  List<ClassifUser> listaItens = snapshot.data;
                  ClassifUser classifUser = listaItens[indice];

                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                image: DecorationImage(
                                    image: NetworkImage(classifUser.urlimage),
                                    fit: BoxFit.cover),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                          ),
                          Expanded(
                              flex: 2,
                              child: Text(
                                classifUser.nome,
                                textAlign: TextAlign.center,
                              )),
                          Expanded(
                              flex: 1,
                              child: Text(
                                classifUser.resultkd,
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
            break;
        }
      },
    );
  }
}


/* 


ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (context, indice) {

                      //recupera mensagem
                      List<DocumentSnapshot> mensagens = querySnapshot.documents.toList();
                      DocumentSnapshot item = mensagens[indice];

                      double larguraContainer =
                          MediaQuery.of(context).size.width * 0.8;

                      //Define cores e alinhamentos
                      Alignment alinhamento = Alignment.centerRight;
                      Color cor = Color(0xffd2ffa5);
                      if ( _idUsuarioLogado != item["idUsuario"] ) {
                        alinhamento = Alignment.centerLeft;
                        cor = Colors.white;
                      }

                      return Align(
                        alignment: alinhamento,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: Container(
                            width: larguraContainer,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: cor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Text(
                              item["mensagem"],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      );
                    }
                    )


*/