import 'package:flutter/material.dart';

class LineBlob extends StatelessWidget {
  final Axis axis;
  final double lineLength;
  final Color lineColor;
  final double lineWidth;

  const LineBlob({
    super.key,
    required this.axis,
    required this.lineLength,
    required this.lineColor,
    required this.lineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: axis == Axis.horizontal ? lineLength : lineWidth,
      height: axis == Axis.vertical ? lineLength : lineWidth,
      decoration: BoxDecoration(
        color: lineColor,
      ),
    );
  }
}
