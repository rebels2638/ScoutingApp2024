import 'package:flutter/material.dart';

extension UsefulScrollController on ScrollController {
  void animateToTop(
          {Duration duration = const Duration(milliseconds: 400),
          Curve curve = Curves.easeInOut}) =>
      animateTo(0, duration: duration, curve: curve);

  void animateToBottom(
          {Duration duration = const Duration(milliseconds: 400),
          Curve curve = Curves.easeInOut}) =>
      animateTo(position.maxScrollExtent,
          duration: duration, curve: curve);
}
