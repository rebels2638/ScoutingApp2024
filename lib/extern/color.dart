import 'package:flutter/material.dart';
import 'package:scouting_app_2024/utils.dart';

int _colorClamp(int i) => clampInt(i, max: 255, min: 0);

extension UsefulColor on Color {
  Color addRed(int value) {
    int fin = red + value;
    fin = _colorClamp(fin);
    return withRed(fin);
  }

  Color addBlue(int value) {
    int fin = blue + value;
    fin = _colorClamp(fin);
    return withBlue(fin);
  }

  Color addGreen(int value) {
    int fin = green + value;
    fin = _colorClamp(fin);
    return withGreen(fin);
  }

  Color addAlpha(int value) {
    int fin = alpha + value;
    fin = _colorClamp(fin);
    return withAlpha(fin);
  }

  Color add({int? r, int? g, int? b, int? a}) {
    Color c = addRed(r ?? 0);
    c = addGreen(g ?? 0);
    c = addBlue(b ?? 0);
    c = addAlpha(a ?? 0);
    return c;
  }

  Color addAll(int rgb) => add(r: rgb, g: rgb, b: rgb);
}
