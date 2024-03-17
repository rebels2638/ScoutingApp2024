import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:scouting_app_2024/extern/alignment.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:scouting_app_2024/utils.dart';

abstract class GradientDescriptor {
  LinearGradient get gr;
}

/// Describes the object layout of a [LinearGradient] class
@JsonSerializable()
class LinearGradientDescriptor implements GradientDescriptor {
  List<Color> colors;
  Alignment beginAlign;
  Alignment endAlign;
  List<double> stops;

  LinearGradientDescriptor(
      {required this.colors,
      required this.beginAlign,
      required this.endAlign,
      required this.stops});

  factory LinearGradientDescriptor.random() {
    List<Color> colors = ColorUtils.randomColors(2, 3);
    List<double> stops = <double>[];
    double step = 1 / (colors.length - 1);
    for (int i = 0; i < colors.length; i++) {
      stops.add(i * step);
    }
    List<Alignment> alignments = Alignment.bottomCenter.values;
    Alignment beginAlign = GenericUtils.pickRandom(alignments);
    alignments.remove(beginAlign);
    Alignment endAlign = GenericUtils.pickRandom(alignments);
    return LinearGradientDescriptor(
        colors: colors,
        beginAlign: beginAlign,
        endAlign: endAlign,
        stops: stops);
  }

  @override
  LinearGradient get gr {
    return LinearGradient(
        colors: colors,
        begin: beginAlign,
        end: endAlign,
        stops: stops);
  }
}
