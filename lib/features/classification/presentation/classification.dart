import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/features/classification/model/user_classification.dart';

class Classification extends StatefulWidget {
  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  //Classes and Packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  //Attributes
  StreamController _controller = StreamController<QuerySnapshot>.broadcast();
  ColorPallete paleta = ColorPallete();
  Color? _corKD;

  _exibirMiniPerfil(UserClassification classifUser) {
    //Calcular Horas
    int minutos = int.parse(classifUser.timeplay);
    String horas = Duration(minutes: minutos).toString().split(':00')[0];

    double kdcor = double.parse(classifUser.killdeath);
    if (kdcor >= 0.00 && kdcor <= 0.74) {
      setState(() {
        _corKD = Colors.red;
      });
    } else if (kdcor >= 0.75 && kdcor <= 0.99) {
      setState(() {
        _corKD = Colors.orange;
      });
    } else if (kdcor >= 1.00) {
      setState(() {
        _corKD = Colors.green;
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: paleta.grey850,
          elevation: 0,
          actionsAlignment: MainAxisAlignment.spaceAround,
          title: Text(
            classifUser.name,
            style: TextStyle(color: Colors.white),
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
              Divider(color: paleta.dodgerBlue),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Kill/ Death",
                    ),
                  ),
                  Text(
                    classifUser.killdeath,
                    style: TextStyle(color: _corKD),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total Kills",
                    ),
                  ),
                  Text(
                    classifUser.kill,
                    style: TextStyle(color: Colors.green[200]),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Total Deaths",
                    ),
                  ),
                  Text(
                    classifUser.death,
                    style: TextStyle(color: Colors.red[200]),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Mvps",
                    ),
                  ),
                  Text(
                    classifUser.mvps,
                    style: TextStyle(color: Colors.blue[200]),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Horas de jogo",
                    ),
                  ),
                  Text(
                    horas,
                    style: TextStyle(color: Colors.blue[200]),
                  ),
                ],
              ),
              Divider(color: paleta.dodgerBlue),
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

  _addListenerMessages() {
    final stream = db
        .collection("users")
        .orderBy("killdeath", descending: true)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _addListenerMessages();
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

                      UserClassification classifUser = UserClassification();
                      classifUser.name = item["name"];
                      classifUser.email = item["email"];
                      classifUser.password = item["password"];
                      classifUser.steamid = item["steamid"];
                      classifUser.userid = item["userid"];
                      classifUser.team = item["team"];
                      classifUser.urlimage = item["urlimage"];
                      classifUser.country = item["country"];
                      classifUser.killdeath = item["killdeath"];
                      classifUser.kill = item["kill"];
                      classifUser.death = item["death"];
                      classifUser.timeplay = item["timeplay"];
                      classifUser.wins = item["wins"];
                      classifUser.mvps = item["mvps"];
                      classifUser.headshots = item["headshots"];

                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(top: 4, bottom: 4),
                          padding: EdgeInsets.all(8),
                          color: paleta.grey850,
                          child: Row(
                            children: [
                              Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(classifUser.urlimage),
                                        fit: BoxFit.cover),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Text(
                                    classifUser.name ?? "",
                                    textAlign: TextAlign.center,
                                  )),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  classifUser.killdeath,
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
                  );
                }
                break;
            }
          },
        ),
      ),
    );
  }
}
