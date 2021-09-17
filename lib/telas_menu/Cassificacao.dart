import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/helper/Paleta.dart';
import 'package:go_status/model/CassifUser.dart';

class Cassificacao extends StatefulWidget {
  @override
  _CassificacaoState createState() => _CassificacaoState();
}

class _CassificacaoState extends State<Cassificacao> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String _emailUsuarioLogado;
  String _idUsuarioLogado;
  Paleta paleta = Paleta();
  User _user;

  Future<List<ClassifUser>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    QuerySnapshot querySnapshot = await db
        .collection("usuarios")
        .orderBy("resultkd", descending: true)
        .get();

    List<ClassifUser> listaUsuarios = List();
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data();
      if (dados["exibirclass"] == false) continue;

      ClassifUser classifUser = ClassifUser();
      classifUser.email = dados["email"];
      classifUser.nome = dados["nome"];
      classifUser.urlimage = dados["urlimage"];
      classifUser.resultkd = dados["resultkd"];
      classifUser.kill = dados["kill"];
      classifUser.mvps = dados["mvps"];
      classifUser.timeplay = dados["timeplay"];

      listaUsuarios.add(classifUser);
    }

    return listaUsuarios;
  }

  _exibirMiniPerfil(ClassifUser classifUser) {
    //Calcular Horas
    int minutos = int.parse(classifUser.timeplay);
    String horas = Duration(minutes: minutos).toString().split(':00')[0];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Text(
            classifUser.nome,
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: CircleAvatar(
                  child: classifUser.urlimage == ""
                      ? CircularProgressIndicator()
                      : ClipOval(child: Image.network(classifUser.urlimage)),
                  radius: 70,
                  backgroundColor: Colors.grey,
                ),
              ),
              Divider(color: paleta.royalBlue),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Kill/ Death",
                      style: TextStyle(
                        color: paleta.royalBlue,
                      ),
                    ),
                  ),
                  Text(
                    classifUser.resultkd,
                    style: TextStyle(color: paleta.royalBlue),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total Kills",
                      style: TextStyle(
                        color: paleta.royalBlue,
                        // decoration: TextDecoration.underline,
                        // decorationStyle: TextDecorationStyle.dotted,
                      ),
                    ),
                  ),
                  Text(
                    classifUser.kill,
                    style: TextStyle(color: paleta.royalBlue),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Mvps",
                      style: TextStyle(
                        color: paleta.royalBlue,
                      ),
                    ),
                  ),
                  Text(
                    classifUser.mvps,
                    style: TextStyle(color: paleta.royalBlue),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Horas de jogo",
                      style: TextStyle(
                        color: paleta.royalBlue,
                      ),
                    ),
                  ),
                  Text(
                    horas,
                    style: TextStyle(color: paleta.royalBlue),
                  ),
                ],
              ),
              Divider(color: paleta.royalBlue),
            ],
          ),
          /*actions: [
            TextButton(
              child: Text("Avaliar"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Mensagem"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],*/
        );
      },
    );
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
                shadowColor: Colors.transparent,
              ),*/
              body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, indice) {
                  List<ClassifUser> listaItens = snapshot.data;
                  ClassifUser classifUser = listaItens[indice];

                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.all(8),
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _exibirMiniPerfil(classifUser);
                    },
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
