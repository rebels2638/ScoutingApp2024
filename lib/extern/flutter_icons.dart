import 'package:flutter/material.dart';

// this goes against idiot proof code

enum FlutterIconEnumMapper {
  beach_access_rounded(Icons.beach_access_rounded),
  factory_rounded(Icons.factory_rounded),
  factory_outlined(Icons.factory_outlined),
  eco_rounded(Icons.eco_rounded),
  android(Icons.android_rounded),
  layers(Icons.layers_rounded),
  nights_stay_rounded(Icons.nights_stay_rounded);

  final IconData data;

  const FlutterIconEnumMapper(this.data);
}
