import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/features/comparison/presentation/widgets/line_comparison.dart';

class CompareGun extends StatefulWidget {
  // const CompareGun({ Key? key }) : super(key: key);

  @override
  _CompareGunState createState() => _CompareGunState();
}

class _CompareGunState extends State<CompareGun> {
  //Classes and packages
  ColorPallete colorPallete = ColorPallete();

  //Attributes
  List<String>? _municao;
  List<String>? _premio;
  List<String>? _damage;
  List<String>? _taxadisparo;
  List<String>? _coice;
  List<String>? _precisao;
  List<String>? _penetracao;

  Key? key;

  List<String>? listring = ['aaaa'];

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
                LineComparison("Munição:", 0.8, 0.9),
                LineComparison("Munição:", 0.8, 0.9),
                LineComparison("Munição:", 0.8, 0.9),
                LineComparison("Munição:", 0.8, 0.9),
                LineComparison("Munição:", 0.8, 0.9),
                LineComparison("Munição:", 0.8, 0.9),
              ],
            ),
            Divider(color: Colors.grey),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(4),
                      children: List.generate(
                        10,
                        (index) {
                          return ElevatedButton(
                            child: Text(
                              'Item de arma',
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
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(4),
                      children: List.generate(
                        10,
                        (index) {
                          return ElevatedButton(
                            child: Text(
                              'Item de arma',
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
                      ),
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
