import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';
import 'package:go_status/core/tools/spliter.dart';
import 'package:go_status/features/comparison/model/comparison_item.dart';

class LineComparison extends StatefulWidget {
  var tittle = "";
  var value01;
  var value02;
  LineComparison(this.tittle, this.value01, this.value02);

  @override
  _LineComparisonState createState() => _LineComparisonState();
}

class _LineComparisonState extends State<LineComparison> {
  //Classes and Packages
  Spliter spliter = Spliter();

  //Attributes
  EdgeInsetsGeometry edgeInsets = EdgeInsets.only(bottom: 4, left: 4, right: 4);
  ColorPallete colorPallete = ColorPallete();
  ComparisonItem cItem1 = ComparisonItem();
  ComparisonItem cItem2 = ComparisonItem();

  Widget _lineGenerator(int currentValue, int maxValue) {
    double percentMax = 100 / maxValue;
    double percentCurrent = percentMax / 100;
    double value = percentCurrent * currentValue;
    print(value);

    return Padding(
      padding: edgeInsets,
      child: LinearProgressIndicator(
        value: value,
        color: colorPallete.orange,
        backgroundColor: Colors.orange[50],
      ),
    );
  }

  @override
  void initState() {
    cItem1.id = 'arma1';
    cItem1.name = 'Arma 01';
    cItem1.ammunition = '20/120';
    cItem1.damage = 30;
    cItem1.firingRate = 6;
    cItem1.penetrationInProtection = 94;
    cItem1.precisionRange = 22;
    cItem1.prizeForKilling = 300;
    cItem1.recoilControl = 83;
    //==
    cItem2.id = 'arma1';
    cItem2.name = 'Arma 01';
    cItem2.ammunition = '20/120';
    cItem2.damage = 35;
    cItem2.firingRate = 8;
    cItem2.penetrationInProtection = 100;
    cItem2.precisionRange = 28;
    cItem2.prizeForKilling = 350;
    cItem2.recoilControl = 90;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(4.0), child: Text('Munição')),
        _lineGenerator(40, 200),
        Padding(
          padding: edgeInsets,
          child: LinearProgressIndicator(
            value: widget.value02 == null ? 0.0 : widget.value02,
            color: colorPallete.dodgerBlue,
            backgroundColor: Colors.blue[50],
          ),
        )
      ],
    );
  }
}
