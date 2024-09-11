import 'dart:ui';

import 'package:flutter/material.dart';

//buttons Colors => green & white // Orange & White

//Heading Colors => dark green & white // Black & White

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

// BG Color
const Colorone = Color(0xFFf9921b);
const Colortwo = Color(0xFFc9de71);
const Colorthree = Color(0xFF74a12a);

// Text color
const txtColorone = Color(0xFF2b2b2b); //black
const txtColortwo = Color(0xFF); //white

// Theme Color
const bgColorOne = Color(0xFFd3e2be);
const bgColorTwo = Color(0xFFfffcf5);
const bgColorThree = Color(0xFFeff2e7);