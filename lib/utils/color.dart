
import 'package:flutter/material.dart';

Color hexToColor(String hexCode) {
  String hex = hexCode.replaceAll('#', '');
  // Si el código es RRGGBB, se le añade el prefijo FF para la opacidad (AARRGGBB)
  if (hex.length == 6) {
    hex = 'FF$hex';
  }
  // Parsea el string hexadecimal a entero y lo convierte a Color
  return Color(int.parse(hex, radix: 16));
}
