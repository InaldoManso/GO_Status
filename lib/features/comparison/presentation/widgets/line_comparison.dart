import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/core/tools/spliter.dart';
import 'package:go_status/features/comparison/model/comparison_item.dart';

class LineComparison extends StatefulWidget {
  ComparisonItem value01;
  ComparisonItem value02;
  LineComparison(this.value01, this.value02);

  @override
  _LineComparisonState createState() => _LineComparisonState();
}

class _LineComparisonState extends State<LineComparison> {
  //Classes and Packages
  Spliter spliter = Spliter();

  //Attributes
  EdgeInsetsGeometry edgeInsets = EdgeInsets.only(bottom: 4, left: 4, right: 4);
  ColorPallete colorPallete = ColorPallete();
  ComparisonItem ci01 = ComparisonItem();
  ComparisonItem ci02 = ComparisonItem();
  int? ammunition1 = 0;
  int? ammunition2 = 0;
  List<String> labels = [
    'Munição:',
    'Prêmio por matar:',
    'Dano:',
    'Taxa de disparo:',
    'Controle de coice:',
    'Precisão a distância:',
    'Penetração em proteção:',
  ];

  Widget _lineGenerator(int currentValue, int maxValue, Color color) {
    double percentMax = 100 / maxValue;
    double percentCurrent = percentMax / 100;
    double value = percentCurrent * currentValue;
    print(value);

    return Padding(
      padding: edgeInsets,
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: value,
              color: color,
              backgroundColor: Colors.orange[50],
            ),
          ),
          Container(
            width: 40,
            child: Center(
              child: Text(
                currentValue.toString(),
                style: TextStyle(fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    ci01 = widget.value01;
    ci02 = widget.value02;
    ammunition1 = spliter.ammunitionResult(ci01.ammunition!);
    ammunition2 = spliter.ammunitionResult(ci02.ammunition!);
    print(ammunition1);
    print(ammunition2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[0])),
          _lineGenerator(ammunition1!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ammunition2!, 200, colorPallete.orange),
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[1])),
          _lineGenerator(ci01.prizeForKilling!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ci02.prizeForKilling!, 200, colorPallete.orange),
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[2])),
          _lineGenerator(ci01.damage!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ci02.damage!, 200, colorPallete.orange),
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[3])),
          _lineGenerator(ci01.firingRate!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ci02.firingRate!, 200, colorPallete.orange),
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[4])),
          _lineGenerator(ci01.recoilControl!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ci02.recoilControl!, 200, colorPallete.orange),
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[5])),
          _lineGenerator(ci01.precisionRange!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ci02.precisionRange!, 200, colorPallete.orange),
          Padding(padding: const EdgeInsets.all(4.0), child: Text(labels[6])),
          _lineGenerator(ci01.penetration!, 200, colorPallete.dodgerBlue),
          _lineGenerator(ci02.penetration!, 200, colorPallete.orange),
        ],
      ),
    );
  }
}
