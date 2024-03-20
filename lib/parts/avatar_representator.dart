import 'package:flutter/material.dart';
import 'package:scouting_app_2024/parts/descriptors/gradient_descriptor.dart';
import 'package:scouting_app_2024/utils.dart';

class AvatarRepresentator extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const AvatarRepresentator({
    super.key,
    this.width = 124,
    this.height = 124,
    this.radius = 9999,
  });

  @override
  State<AvatarRepresentator> createState() =>
      _AvatarRepresentatorState();
}

class _AvatarRepresentatorState extends State<AvatarRepresentator> {
  late LinearGradientDescriptor _descriptor;

  @override
  void initState() {
    super.initState();
    _descriptor = LinearGradientDescriptor.random();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(
          () => _descriptor = LinearGradientDescriptor.random()),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.radius),
                gradient: _descriptor.gr)),
      ),
    );
  }
}

class GlowingAvatarRepresentator extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final double glowSpreadRadius;
  final double glowBlurRadius;

  const GlowingAvatarRepresentator({
    super.key,
    this.width = 124,
    this.height = 124,
    this.glowSpreadRadius = 3.0,
    this.glowBlurRadius = 10.0,
    this.radius = 9999,
  });

  @override
  State<GlowingAvatarRepresentator> createState() =>
      _GlowingAvatarRepresentatorState();
}

class _GlowingAvatarRepresentatorState
    extends State<GlowingAvatarRepresentator> {
  late LinearGradientDescriptor _descriptor;

  @override
  void initState() {
    super.initState();
    _descriptor = LinearGradientDescriptor.random();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(
          () => _descriptor = LinearGradientDescriptor.random()),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
              for (Color r in _descriptor.colors)
                BoxShadow(
                    color: r.withAlpha(rng.nextInt(200) + 150),
                    blurRadius: widget.glowBlurRadius,
                    spreadRadius: widget.glowSpreadRadius,
                    offset: const Offset(0, 0))
            ],
                borderRadius: BorderRadius.circular(widget.radius),
                gradient: _descriptor.gr)),
      ),
    );
  }
}
