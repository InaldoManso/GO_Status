import 'package:flutter/material.dart';
import 'package:go_status/core/helper/color_pallete.dart';

class LineComparison extends StatefulWidget {
  var tittle = "";
  var value01;
  var value02;
  LineComparison(this.tittle, this.value01, this.value02);

  @override
  _LineComparisonState createState() => _LineComparisonState();
}

class _LineComparisonState extends State<LineComparison> {
  //classes and Packages
  ColorPallete colorPallete = ColorPallete();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(4.0), child: Text(widget.tittle)),
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
          child: LinearProgressIndicator(
            value: widget.value01 == null ? 0.0 : widget.value01,
            color: colorPallete.orange,
            backgroundColor: Colors.orange[50],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
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
