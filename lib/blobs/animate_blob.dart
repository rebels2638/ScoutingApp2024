import 'package:flutter/material.dart';

class SpinBlob extends StatefulWidget {
  final Widget child;
  final int period;

  const SpinBlob(
      {super.key, required this.child, this.period = 2000});

  @override
  State<SpinBlob> createState() => _SpinBlobState();
}

class _SpinBlobState extends State<SpinBlob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: widget.period), vsync: this)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: widget.child,
    );
  }
}
