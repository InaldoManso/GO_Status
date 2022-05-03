import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/features/comparison/model/comparison_item.dart';
import 'package:go_status/features/comparison/presentation/widgets/line_comparison.dart';

class CompareGun extends StatefulWidget {
  @override
  _CompareGunState createState() => _CompareGunState();
}

class _CompareGunState extends State<CompareGun> {
  //Classes and packages
  FirebaseFirestore db = FirebaseFirestore.instance;
  ColorPallete colorPallete = ColorPallete();

  //Attributes
  StreamController _controller = StreamController<QuerySnapshot>.broadcast();
  Widget lines = Container(child: Center(child: CircularProgressIndicator()));
  ComparisonItem? initCi01 = ComparisonItem();
  ComparisonItem? initCi02 = ComparisonItem();
  String? gunTittle01 = 'Selecione';
  String? gunTittle02 = 'Selecione';

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

  _initializeInterface(bool initconfig,
      {int? item, ComparisonItem? ci01, ComparisonItem? ci02}) {
    if (initconfig) {
      initCi01!.id = 'arma1';
      initCi01!.name = 'Arma 01';
      initCi01!.ammunition = '20/120';
      initCi01!.damage = 180;
      initCi01!.firingRate = 180;
      initCi01!.penetration = 180;
      initCi01!.precisionRange = 180;
      initCi01!.prizeForKilling = 180;
      initCi01!.recoilControl = 180;

      initCi02!.id = 'arma1';
      initCi02!.name = 'Arma 01';
      initCi02!.ammunition = '20/120';
      initCi02!.damage = 180;
      initCi02!.firingRate = 180;
      initCi02!.penetration = 180;
      initCi02!.precisionRange = 180;
      initCi02!.prizeForKilling = 180;
      initCi02!.recoilControl = 180;

      setState(() {
        lines = LineComparison(initCi01!, initCi02!);
      });
    } else if (initconfig == false && item == 1) {
      initCi01!.id = ci01!.id ?? "";
      initCi01!.name = ci01.name ?? "";
      initCi01!.ammunition = ci01.ammunition ?? "";
      initCi01!.damage = ci01.damage ?? 0;
      initCi01!.firingRate = ci01.firingRate ?? 0;
      initCi01!.penetration = ci01.penetration ?? 0;
      initCi01!.precisionRange = ci01.precisionRange ?? 0;
      initCi01!.prizeForKilling = ci01.prizeForKilling ?? 0;
      initCi01!.recoilControl = ci01.recoilControl ?? 0;
      setState(() {
        gunTittle01 = ci01.name;
        lines = LineComparison(initCi01!, initCi02!);
      });
    } else if (initconfig == false && item == 2) {
      initCi02!.id = ci02!.id ?? "";
      initCi02!.name = ci02.name ?? "";
      initCi02!.ammunition = ci02.ammunition ?? "";
      initCi02!.damage = ci02.damage ?? 0;
      initCi02!.firingRate = ci02.firingRate ?? 0;
      initCi02!.penetration = ci02.penetration ?? 0;
      initCi02!.precisionRange = ci02.precisionRange ?? 0;
      initCi02!.prizeForKilling = ci02.prizeForKilling ?? 0;
      initCi02!.recoilControl = ci02.recoilControl ?? 0;
      setState(() {
        gunTittle02 = ci02.name;
        lines = LineComparison(initCi01!, initCi02!);
      });
    }
  }

  @override
  void initState() {
    _initializeInterface(true);
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                gunTittle01!,
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
                                gunTittle02!,
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
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey),
            lines,
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
                                  comparisonItem.penetration =
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
                                    onPressed: () {
                                      _initializeInterface(false,
                                          ci01: comparisonItem, item: 1);
                                    },
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
                                  comparisonItem.penetration =
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
                                    onPressed: () {
                                      _initializeInterface(false,
                                          ci02: comparisonItem, item: 2);
                                    },
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
