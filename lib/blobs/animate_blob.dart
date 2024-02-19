import 'package:flutter/material.dart';

class SpinBlob extends StatefulWidget {
  final Widget child;
  final int period;

  const SpinBlob(
      {super.key, required this.child, this.period = 600});

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      filterQuality: FilterQuality.high,
      child: widget.child,
    );
  }
}
