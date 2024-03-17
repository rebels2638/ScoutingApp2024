import 'package:flutter/material.dart';

extension UsefulAlignment on AlignmentGeometry {
  List<Alignment> get values {
    return <Alignment>[
      Alignment.topLeft,
      Alignment.topCenter,
      Alignment.topRight,
      Alignment.centerLeft,
      Alignment.center,
      Alignment.centerRight,
      Alignment.bottomLeft,
      Alignment.bottomCenter,
      Alignment.bottomRight
    ];
  }
}
