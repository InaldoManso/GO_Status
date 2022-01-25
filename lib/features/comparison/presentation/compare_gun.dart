import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/features/comparison/model/comparison_item.dart';
import 'package:go_status/features/comparison/presentation/widgets/line_comparison.dart';

class CompareGun extends StatefulWidget {
  // const CompareGun({ Key? key }) : super(key: key);

  @override
  _CompareGunState createState() => _CompareGunState();
}

class _CompareGunState extends State<CompareGun> {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  ColorPallete colorPallete = ColorPallete();

  //Attributes
  StreamController _controller = StreamController<QuerySnapshot>.broadcast();
  int? _municao;
  int? _premio;
  int? _damage;
  int? _taxadisparo;
  int? _coice;
  int? _precisao;
  int? _penetracao;

  int? _municao2;
  int? _premio2;
  int? _damage2;
  int? _taxadisparo2;
  int? _coice2;
  int? _precisao2;
  int? _penetracao2;

  List<String>? listring = ['aaaa'];

  Stream<QuerySnapshot> _addListenerCompareGuns() {
    final stream = db
        .collection("interface")
        .doc("comparison")
        .collection("guns")
        .orderBy("category", descending: false)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
    return stream;
  }

  @override
  void initState() {
    _addListenerCompareGuns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Comparador'),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 40,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: width * 0.3,
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned(
                          right: 1,
                          bottom: 1,
                          child: Container(
                            height: width * 0.25,
                            width: width * 0.25,
                            color: colorPallete.orange,
                          ),
                        ),
                        Positioned(
                          top: 1,
                          left: 1,
                          child: Container(
                            height: width * 0.25,
                            width: width * 0.25,
                            color: colorPallete.dodgerBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Center(
                            widthFactor: 1,
                            child: Text(
                              'Nome da arma pô',
                              style: TextStyle(
                                fontSize: 20,
                                color: colorPallete.dodgerBlue,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            widthFactor: 2,
                            child: Text(
                              'Nome da arma pô',
                              style: TextStyle(
                                fontSize: 20,
                                color: colorPallete.orange,
                              ),
                            ),
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            Column(
              children: [
                LineComparison("Munição:", 0.8, 0.9),
                LineComparison("Prêmio por matar:", 0.8, 0.9),
                LineComparison("Dano:", 0.8, 0.9),
                LineComparison("Taxa de disparo:", 0.8, 0.9),
                LineComparison("Controle de coice:", 0.8, 0.9),
                LineComparison("Precisão a distância:", 0.8, 0.9),
                LineComparison("Penetração em proteção:", 0.8, 0.9),
              ],
            ),
            Divider(color: Colors.grey),
            Expanded(
              child: Row(
                children: [
                  Expanded(
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
                                padding: EdgeInsets.all(4),
                                itemCount: querySnapshot!.docs.length,
                                itemBuilder: (context, index) {
                                  //Recuperar mensagens
                                  List<DocumentSnapshot> snappingItemsList =
                                      querySnapshot.docs.toList();

                                  DocumentSnapshot item =
                                      snappingItemsList[index];

                                  ComparisonItem comparisonItem =
                                      ComparisonItem();

                                  comparisonItem.id = item["id"];
                                  comparisonItem.name = item["name"];
                                  comparisonItem.ammunition =
                                      item["ammunition"];
                                  comparisonItem.damage = item["damage"];
                                  comparisonItem.firingRate =
                                      item["firingRate"];
                                  comparisonItem.penetrationInProtection =
                                      item["penetrationInProtection"];
                                  comparisonItem.precisionRange =
                                      item["precisionRange"];
                                  comparisonItem.prizeForKilling =
                                      item["prizeForKilling"];
                                  comparisonItem.recoilControl =
                                      item["recoilControl"];

                                  return ElevatedButton(
                                    child: Text(
                                      comparisonItem.name!,
                                      style: TextStyle(
                                        color: colorPallete.dodgerBlue,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: colorPallete.orange,
                                    ),
                                    onPressed: () {},
                                  );
                                },
                              );
                            }
                        }
                      },
                    ),
                  ),
                  Expanded(
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
                                padding: EdgeInsets.all(4),
                                itemCount: querySnapshot!.docs.length,
                                itemBuilder: (context, index) {
                                  //Recuperar mensagens
                                  List<DocumentSnapshot> snappingItemsList =
                                      querySnapshot.docs.toList();

                                  DocumentSnapshot item =
                                      snappingItemsList[index];

                                  ComparisonItem comparisonItem =
                                      ComparisonItem();

                                  comparisonItem.id = item["id"];
                                  comparisonItem.name = item["name"];
                                  comparisonItem.ammunition =
                                      item["ammunition"];
                                  comparisonItem.damage = item["damage"];
                                  comparisonItem.firingRate =
                                      item["firingRate"];
                                  comparisonItem.penetrationInProtection =
                                      item["penetrationInProtection"];
                                  comparisonItem.precisionRange =
                                      item["precisionRange"];
                                  comparisonItem.prizeForKilling =
                                      item["prizeForKilling"];
                                  comparisonItem.recoilControl =
                                      item["recoilControl"];

                                  return ElevatedButton(
                                    child: Text(
                                      comparisonItem.name!,
                                      style: TextStyle(
                                        color: colorPallete.orange,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: colorPallete.dodgerBlue,
                                    ),
                                    onPressed: () {},
                                  );
                                },
                              );
                            }
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
