import 'package:flutter/material.dart';

class Spliter {
  int ammunitionResult(String ammunition) {
    List<String> hexa = ammunition.split("/");
    int value1 = int.parse(hexa[0]);
    int value2 = int.parse(hexa[1]);

    int finalValue = value1 + value2;
    return finalValue;
  }
}
