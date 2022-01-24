// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';

class TittleSearch extends StatefulWidget {
  var tittle;
  TittleSearch(this.tittle);

  @override
  _TittleSearchState createState() => _TittleSearchState();
}

class _TittleSearchState extends State<TittleSearch> {
  String? _valueTittle(String value) {
    if (value == "") {
      return "League Master Club";
    } else {
      return "\"" + value + "\"";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _valueTittle(widget.tittle!)!,
      style: TextStyle(color: Colors.white),
    );
  }
}
