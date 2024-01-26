import 'dart:ui';

import 'package:flutter/material.dart';

class ObfsBlob extends StatelessWidget {
  final Widget child;
  final double? sigmaX;
  final double? sigmaY;
  final TileMode? tileMode;

  const ObfsBlob(
      {super.key,
      required this.child,
      this.sigmaX,
      this.sigmaY,
      this.tileMode});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      child,
      BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: sigmaX ?? 0,
              sigmaY: sigmaY ?? 0,
              tileMode: tileMode ?? TileMode.clamp),
          child: Container(color: Colors.transparent))
    ]);
  }
}
