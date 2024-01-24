import 'package:flutter/material.dart';

typedef ColorFloatStrip = ({
  double red,
  double green,
  double blue,
  double alpha
});

extension UsefulColor on Color {
  Color grayScale() {
    ColorFloatStrip stripped = strip();
    int val = ((0.299 * stripped.red +
                0.587 * stripped.green +
                0.114 * stripped.blue) *
            255)
        .toInt()
        .clamp(0, 255);
    return Color.fromARGB(
        (stripped.alpha * 255).toInt(), val, val, val);
  }

  ColorFloatStrip strip() => (
        red: red / 255.toDouble(),
        green: green / 255.toDouble(),
        blue: blue / 255.toDouble(),
        alpha: alpha / 255.toDouble()
      );

  Color biContrastingColor(
      {Color dark = Colors.black, Color light = Colors.white}) {
    ColorFloatStrip stripped = strip();
    // thx to this stackoverflow answer for the weights: https://stackoverflow.com/a/3943023
    return (0.299 * stripped.red +
                0.587 * stripped.green +
                0.114 * stripped.blue) >
            0.200 // custom threshold
        ? dark
        : light;
  }

  Color invert() =>
      withRed(255 - red).withGreen(255 - green).withBlue(255 - blue);

  Color addRed(int value) {
    int fin = red + value;
    fin = fin.clamp(0, 255);
    return withRed(fin);
  }

  Color addBlue(int value) {
    int fin = blue + value;
    fin = fin.clamp(0, 255);
    return withBlue(fin);
  }

  Color addGreen(int value) {
    int fin = green + value;
    fin = fin.clamp(0, 255);
    return withGreen(fin);
  }

  Color addAlpha(int value) {
    int fin = alpha + value;
    fin = fin.clamp(0, 255);
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
