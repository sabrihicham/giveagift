import 'package:flutter/material.dart';

extension ColorsExtension on Color {
  String get hex {
    return '#${value.toRadixString(16).substring(2)}';
  }

  Color get lighter {
    return Color.fromRGBO(
      red + 50 > 255 ? 255 : red + 50,
      green + 50 > 255 ? 255 : green + 50,
      blue + 50 > 255 ? 255 : blue + 50,
      opacity,
    );
  }

  Color get darker {
    return Color.fromRGBO(
      red - 50 < 0 ? 0 : red - 50,
      green - 50 < 0 ? 0 : green - 50,
      blue - 50 < 0 ? 0 : blue - 50,
      opacity,
    );
  }
}